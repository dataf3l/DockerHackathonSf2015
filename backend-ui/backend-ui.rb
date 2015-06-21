require 'sinatra'
require "sinatra/reloader"
require 'pp'
require 'Open3'
load 'runcommand.rb'

enable :run

def parse_env(e) 
#
#   parse the output of docker env machine into something meaningful
#
#	export DOCKER_TLS_VERIFY="1"
#   export DOCKER_HOST="tcp://45.55.67.122:2376"
#   export DOCKER_CERT_PATH="/Users/a/.docker/machine/machines/do"
#   export DOCKER_MACHINE_NAME="do"
#   # Run this command to configure your shell: 
#   # eval "$(docker-machine env do)"

	dx =""
	envvars = Hash.new
	dx += "<ul>"
	e.split("\n").each { |line|
		next if line[0] =="#" #ignore comments
		line_parts = line.split(" ")[1].gsub('"',"").split("=")
		var_name = line_parts[0]
		var_value = line_parts[1]
		envvars[var_name] = var_value
		ENV[var_name] = var_value
		dx += "<li>#{var_name} =&gt; #{ENV[var_name]}</li>"
	}
	dx += "</ul>"
	dx += "<h2>Environment:</h2>"

	dx += "<ul>"
	ENV.each {|key,value|
		if key =~ /^DOCKER/ then	
			dx += "<li><b>#{key}</b> == #{value} </li>"
		end
	}
	dx += "</ul>"
	
	dx

end

def get_images(machine_name, show_all)
	dx = ""
	if show_all == "0" then
		images = %x[docker images]
	else
		images = %x[docker images -a]
	end

	images = %x[docker images]
	dx += "<h2>Images</h2>"
	dx += "<table border=1>"
	c = 0
	images.split("\n").each {|image|
		if c == 0 then
		  #print headers
		  dx += "<tr><th>"
		  parts = image.split(/ {4,40}/)
		  dx += parts.join("</th><th>")
		  dx += "<th>&nbsp;</th>"
		  dx += "</th></tr>"
		else
		  k_image_id = 2
		  k_repo = 0
		  k_tag = 1

		  dx += "<tr><td>"
		  image = image.gsub("<","&lt;").gsub(">","&gt;")  # todo html entities
		  parts = image.split(/ {4,40}/)
		  parts[k_image_id] = "<a href='#'>" + parts[k_image_id] + "</a>"
		  dx += parts.join("</td><td>")
		  repo = parts[k_repo]
		  tag = parts[k_tag]
		  dx += "</td><td>"
		  dx += "<a href='?run_image=1&machine_name=#{machine_name}&repo=#{repo}&tag=#{tag}'>Start Container</a>"
		  dx += "</td></tr>"
		end

		c += 1

	}
	dx += "</table>"
	dx += "<pre>#{images}</pre>"
	dx 
end

get '/' do
  dx = ""
  dx += "<a href='/'>Back to List of machines</a><br/>"
  dx += "<a href='/?create_form=1'>Create a new Machine</a><br/>"

  if params.has_key?("run_image_ok") then
  	dx += "running machine here..."
	
	container_name = params["container_name"]
	machine_port = params["machine_port"]
	container_port = params["container_port"]
	tag = params["tag"]
	repo = params["repo"]
	machine = params["machine"]
	
	#todo run env first...

	results, err, status = Open3.capture3("docker", "run", "--name",container_name,"-p",machine_port+":"+container_port,"-d", repo+":"+tag)
	dx += "<pre>" + results + "</pre>"
	dx += "<hr>"
	dx += "<pre>" + err + "</pre>"
	dx += "<hr>"

  elsif params.has_key?("run_image") then
	repo = params["repo"]
	tag = params["tag"]
	machine_name = params["machine_name"]
	
	dx += %{
		<form method=GET> 
			<input type=hidden name=run_image_ok value=1>
			<h1>Create Container from Image: #{repo}:#{tag}</h1>
			<label>
				Container Name:
				<br/>	
				<input name='container_name' value="" required  />
			</label>
			<br/>
			<label>
				Machine Port:
				<br/>	
				<input name='machine_port' value="80"  />
			</label>
			<br/>
			<label>
				Container Port:
				<br/>	
				<input name='container_port' value="80"  />
			</label>
			<br/>
			<label>
				Repository:
				<br/>	
				<input name='repo' value="#{repo}" readonly />
			</label>
			<br/>
			<label>
				Tag:
				<br/>	
				<input name='tag'  value="#{tag}" readonly />
			</label>
			<br/>
			<label>
				Machine:
				<br/>	
				<input name='machine'  value="#{machine_name}" readonly  />
			</label>
			<br/>
			<input type=submit value='Spawn Image' />
		</form>

	}
	
  elsif params.has_key?("create_form_ok") then
  	dx += "yeah"
		  
  elsif params.has_key?("create_form") then
	
	dx += %{
		<form method=GET> 
			<input type=hidden name=create_form_ok value=1>
			<h1>Create new Machine</h1>
			<label>
				Machine Name:
				<br/>	
				<input name='machine_name' />
			</label>
			<br/>
			<label>
				Machine Type :
				<br/>	
				<select name='machine_type' >
					<option value='virtualbox>Virtual Box</option>
					<option value='digitalocean>Digital Ocean</option>
				</select>
			</label>
			<input type=submit value='Create Machine' />
		</form>

	}
	

  elsif params.has_key?("start_machine") then
	m = params["start_machine"]
	dx += "Starting Machine: #{m} ..."
	
	results, err, status = Open3.capture3("docker-machine", "start", m)
	dx += "<pre>#{results}</pre>"
	

  elsif params.has_key?("stop_machine") then
	m = params["stop_machine"]
	dx += "Stopping Machine: #{m} ..."
	results, err, status = Open3.capture3("docker-machine", "stop", m)
	dx += "<pre>#{results}</pre>"

  elsif params.has_key?("machine") then
    m = params["machine"]
    dx += "<h1>Machine Selected:#{m}</h1>"
	dx += "<a href='?machine=#{m}&show_all=0'>Show Active</a>"
	dx += "|"
	dx += "<a href='?machine=#{m}&show_all=1'>Show All</a>"

	e = %x[docker-machine env #{m}]
	dx += parse_env e
	sa = "0"
	if params.has_key?("show_all") then
		sa = params["show_all"]
	end

	dx += get_images(m, sa)
	#dx += "<pre>#{e}</pre>"

  else
    dx +=  machines()
  end

  dx += "<hr/>Web console v0.1"

  dx
end

