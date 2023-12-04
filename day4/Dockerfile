FROM debian

RUN apt update && apt install -y build-essential nasm

CMD nasm -felf64 /data/part1.asm -o main.o && ld main.o -o main && ./main
