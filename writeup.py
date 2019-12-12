import string
import itertools

def hash(password):
	calculated_hash = 0

	for char in password:
		calculated_hash = ((calculated_hash << 2) + ord(char)) & 0xffff

	return calculated_hash

def main():
	chars = string.ascii_uppercase + string.digits

	for item in itertools.product(chars, repeat=8):
		password = ''.join(item)

		if hash(password) == 0xcfe1:
			print 'Password: ' + password
			break

if __name__ == '__main__':
	main()
