module MessagesHelper

	def messages_class
		if messages.read?
			html = "class='message'"
		else
			html = "class='message read'"
		end
		html.html_safe
	end

end
