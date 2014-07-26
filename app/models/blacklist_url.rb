class BlacklistUrl < ActiveRecord::Base

	after_create :strip_to_host
	after_save :dedupe

	def strip_to_host
		uri = URI.parse(self.domain)
  		uri = URI.parse("http://#{self.domain}") if uri.scheme.nil?
  		host = uri.host.downcase
  		host.start_with?('www.') ? host[4..-1] : host # get host name

		self.update_attributes(:domain => host)
	end

	def dedupe
    # find all blacklist urls and group them by domain
	   grouped = BlacklistUrl.all.group_by(&:domain)
	   grouped.values.each do |duplicates|
      # the first one we want to keep right?
			first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
		    duplicates.each{|double| double.destroy} # duplicates can now be destroyed
	    end
	end
end
