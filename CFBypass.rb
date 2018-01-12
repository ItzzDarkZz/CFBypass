#!/usr/bin/env ruby
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

def banner()
red = "\033[01;31m"
green = "\033[01;32m"


puts "\n"
                                                                                                                                                               
        

                                                                                                                                                               
puts "#{red}Tool for bypassinc CloudFlare DDOS protection."
puts "For more help:"
puts "Discord  -->  ItzzDarkZz#2956"

puts "\n"
puts "        CCCCCCCCCCCCCFFFFFFFFFFFFFFFFFFFFFFBBBBBBBBBBBBBBBBB                                                                                                   "
puts "     CCC::::::::::::CF::::::::::::::::::::FB::::::::::::::::B                                                                                                  "
puts "   CC:::::::::::::::CF::::::::::::::::::::FB::::::BBBBBB:::::B                                                                                                 "
puts "  C:::::CCCCCCCC::::CFF::::::FFFFFFFFF::::FBB:::::B     B:::::B                                                                                                "
puts " C:::::C       CCCCCC  F:::::F       FFFFFF  B::::B     B:::::Byyyyyyy           yyyyyyyppppp   ppppppppp     aaaaaaaaaaaaa      ssssssssss       ssssssssss   "
puts "C:::::C                F:::::F               B::::B     B:::::B y:::::y         y:::::y p::::ppp:::::::::p    a::::::::::::a   ss::::::::::s    ss::::::::::s  "
puts "C:::::C                F::::::FFFFFFFFFF     B::::BBBBBB:::::B   y:::::y       y:::::y  p:::::::::::::::::p   aaaaaaaaa:::::ass:::::::::::::s ss:::::::::::::s "
puts "C:::::C                F:::::::::::::::F     B:::::::::::::BB     y:::::y     y:::::y   pp::::::ppppp::::::p           a::::as::::::ssss:::::ss::::::ssss:::::s"
puts "C:::::C                F:::::::::::::::F     B::::BBBBBB:::::B     y:::::y   y:::::y     p:::::p     p:::::p    aaaaaaa:::::a s:::::s  ssssss  s:::::s  ssssss "
puts "C:::::C                F::::::FFFFFFFFFF     B::::B     B:::::B     y:::::y y:::::y      p:::::p     p:::::p  aa::::::::::::a   s::::::s         s::::::s      "
puts "C:::::C                F:::::F               B::::B     B:::::B      y:::::y:::::y       p:::::p     p:::::p a::::aaaa::::::a      s::::::s         s::::::s   "
puts " C:::::C       CCCCCC  F:::::F               B::::B     B:::::B       y:::::::::y        p:::::p    p::::::pa::::a    a:::::assssss   s:::::s ssssss   s:::::s "
puts "  C:::::CCCCCCCC::::CFF:::::::FF           BB:::::BBBBBB::::::B        y:::::::y         p:::::ppppp:::::::pa::::a    a:::::as:::::ssss::::::ss:::::ssss::::::s"
puts "   CC:::::::::::::::CF::::::::FF           B:::::::::::::::::B          y:::::y          p::::::::::::::::p a:::::aaaa::::::as::::::::::::::s s::::::::::::::s "
puts "     CCC::::::::::::CF::::::::FF           B::::::::::::::::B          y:::::y           p::::::::::::::pp   a::::::::::aa:::as:::::::::::ss   s:::::::::::ss  "
puts "        CCCCCCCCCCCCCFFFFFFFFFFF           BBBBBBBBBBBBBBBBB          y:::::y            p::::::pppppppp      aaaaaaaaaa  aaaa sssssssssss      sssssssssss    "
puts "                                                                     y:::::y             p:::::p                                                               "
puts "                                                                    y:::::y              p:::::p                                                               "
puts "                                                                   y:::::y              p:::::::p                                                              "
puts "                                                                  y:::::y               p:::::::p                                                              "
puts "                                                                 yyyyyyy                p:::::::p                                                              "
puts "                                                                                        ppppppppp                                                              "


end

options = {:bypass => nil, :massbypass => nil}
parser = OptionParser.new do|opts|

    opts.banner = "Example Use: ruby CFBypass.rb -b [Target URL] or ruby CFBypass.rb --byp [Target URL]"
    opts.on('-b ','--byp ', 'Discover real IP (bypass CloudFlare)', String)do |bypass|
    options[:bypass]=bypass;
    end

    opts.on('-o', '--out', 'Next release.', String) do |massbypass|
        options[:massbypass]=massbypass

    end

    opts.on('-h', '--help', 'Help') do
        banner()
        puts opts
        puts "Example: ruby CFBypass.rb -b facebook.com or ruby CFBypass.rb --byp facebook.com"
        exit
    end
end

parser.parse!


banner()

if options[:bypass].nil?
    puts "Insert URL -b or --byp"
else
	option = options[:bypass]
	payload = URI ("http://www.crimeflare.org/cgi-bin/cfsearch.cgi")
	request = Net::HTTP.post_form(payload, 'cfS' => options[:bypass])

	response =  request.body
	nscheck = /No working nameservers are registered/.match(response)
	if( !nscheck.nil? )
		puts "[-] No valid address - are you sure this is a CloudFlare protected domain?\n"
		exit
	end
	regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
	if( regex.nil? || regex == "" )
		puts "[-] Not a valid address - are you sure this is a CloudFlare protected domain?\n"
		puts "[-] Alternately, maybe crimeflare.org is down? Try it by hand.\n"
		exit
	end
	ip_real = IPSocket.getaddress (options[:bypass])

	puts "[+] Site analysis: #{option} "
	puts "[+] CloudFlare Protected IP is #{ip_real} "
	puts "[+] Unprotected IP is #{regex}"
	target = "http://ipinfo.io/#{regex}/json"
	url = URI(target).read
	json = JSON.parse(url)
	puts "[+] Hostname: " + json['hostname']
	puts "[+] City: "  + json['city']
	puts "[+] Region: " + json['country']
	puts "[+] Location: " + json['loc']
	puts "[+] Organization: " + json['org']

end
