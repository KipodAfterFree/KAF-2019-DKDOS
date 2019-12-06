from threading import Lock, Thread
from time import sleep
from socket import SO_REUSEADDR, SOCK_STREAM, socket, SOL_SOCKET, AF_INET

CLIENT_MESSAGE = """MS-DOS KIPOD SHOP
------------------------------------------------
Wanna buy some KIPODIM?
First, I have to make sure you're allowed to.
Please log in with you password: """

FLAG = 'KAF{D05_15_JU57_700_C00L}'
INVALID = 'Man this is not the right password :('

s = socket(AF_INET, SOCK_STREAM)
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
s.bind(('0.0.0.0', 8000))

threads = []

def hash(password):
    sleep(1)

    if len(password) != 8:
        return 0

    calculated_hash = 0

    for char in password:
        calculated_hash = ((calculated_hash << 1) + ord(char)) & 0xffff

    return calculated_hash

class ClientHandler(Thread):
    def __init__(self, address, port, socket):
        Thread.__init__(self)
        self.address = address
        self.port = port
        self.socket = socket

    def run(self):
        self.socket.send(CLIENT_MESSAGE)

        password = self.socket.recv(4096).replace('\n', '')

        if hash(password) == 0x43e5:
            self.socket.send('\n' + FLAG)
        else:
            self.socket.send('\n' + INVALID)

        self.socket.close()

while 1:
    s.listen(1)
    
    sock, addr = s.accept()
    
    newThread = ClientHandler(addr[0], addr[1], sock)
    newThread.start()
    
    threads.append(newThread)