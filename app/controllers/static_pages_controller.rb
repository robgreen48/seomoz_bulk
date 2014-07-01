class StaticPagesController < ApplicationController
  
  def home
  	client = Linkscape::Client.new(:accessID => "member-20de2fa4a6", :secret => "0d8ac3e7fe8ca9173e0e6fdb321d3102")
  	@response = client.urlMetrics("http://www.propellernet.co.uk", :cols => :all)
  end

end
