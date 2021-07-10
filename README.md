# reverse-shell-nim
A simple reverse shell written in Nim

## Usage
1. Download a binary from the [release page](https://github.com/0x454d505459/reverse-shell-nim/releases)
2. Make it executable with `chmod u+x ./client`
3. Run a netcat listener on port `5645`
4. Have fun

## Compiling
If you want to compile the reverse shell by yourself:
1. Clone this `git clone https://github.com/0x454d505459/reverse-shell-nim.git`
2. Change to the directory `cd reverse-shell-nim`
3. Use the nim compiler `nim c -d:ssl client.nim
4. It's done! You can now use it

## Built-in commands
- run EXECUTABE
	+ Run anything without having to know the OS command
- url-open LINK
	+ Open any link into the default victim browser
- sys-infos
	+ Return the OS, cpu architecture and the IP of the victim
	

## Disclaimer
This tool was made for educationnal purpose **ONLY**; I will not take the responsabilities of what you do witih this sofware.
