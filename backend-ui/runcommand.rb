
def machines() 
	dx = "<h1>List of Machines</h1>"
	dx += "<table border=1>\n"
	a = %x[docker-machine ls -q]
	a.split("\n").each  {|line| 
		dx += "<tr><td>"
		dx += "<a href='/?machine=#{line}&show_all=0'>#{line} </a>\n"
		dx += "</td><td>"
		dx += "<a href='/?start_machine=#{line}'> Start </a>\n"
		dx += "</td><td>"
		dx += "<a href='/?stop_machine=#{line}'> Stop </a>\n"
		dx += "</td></tr>"
	}
	
	dx += "</table>\n"
	dx += "<pre>" + %x[docker-machine ls] + "</pre>"
	dx
end

#puts machines()
