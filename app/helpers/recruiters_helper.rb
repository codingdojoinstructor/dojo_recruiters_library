module RecruitersHelper
	def display_url(url)
		if url.index("http://").nil? and url.index("https://").nil?
			url = "http://" + url
	    end

	    url
	end
end
