# DKDOS

DKDOS is an information security challenge in the reversing category, and was presented to participants of [KAF CTF 2019](https://play.kaf.sh)

## Challenge story

I've sent my KIPODIM shop to a friend of mine, and he told me he was able to access it with just a random password. Can you please check it?

## Challenge exploit

The challenge features a common software vulnerability called hash collision.
In order to exploit it, you should find an input that will generate the hash 0x43e5 with the hashing algorithm in the software.
You can do it either in a mathematical way, or using bruteforce. Both options work, but the bruteforce way is probably easier.

## Challenge solution

The challenge consists of 2 parts. The first one is understanding the functionality of the program, and the second one is exploiting the hash collision vulnerability.

In the first part, the solvers should first understand the architecture on which the binary runs and the general flow of it, and then realize that the code is self-modifying. After that, the solvers should find out the length of the password, understand the hashing algorithm and understand that it is vulnerable to hash collision.

In the second part, the solvers should find another password that hashes to 0x43e5. The way I did it was by bruteforcing. I represented the hashing algorithm in Python and just tried all optional values. The solution code is [here](writeup.py).

## Building and installing

[Clone](https://github.com/omerk2511/KAF-2019-DKDOS/archive/master.zip) the repository, then type the following command to build the container:
```bash
docker build . -t dkdos
```

To run the challenge, execute the following command:
```bash
docker run --rm -d -p 6000:8000 dkdos
```

## Usage

You may now access the challenge interface through netcat: `nc 127.0.0.1 8000`

## Flag

Flag is:
```flagscript
KAF{D05_15_JU57_700_C00L}
```

## License
[MIT License](https://choosealicense.com/licenses/mit/)
