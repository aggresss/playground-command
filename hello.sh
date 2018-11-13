# hello test for various kinds of language

# linux shell color support.
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"
NORMAL="\\033[m"

HELLO_TYPE=$1
case ${HELLO_TYPE} in
    c)
        cat << END > /tmp/hello.c
#include <stdio.h>
int main()
{
    printf("Hello World!\n");
    return 0;
}
END
        echo -e "${GREEN}/tmp/hello.c${NORMAL}"
        #gcc -v /tmp/hello.c 2> /tmp/hello.c.txt
        #gcc -v /tmp/hello.c
        #rm -rf /tmp/hello.c* a.out
    ;;
    cpp)
        cat << END > /tmp/hello.cpp
#include <iostream>
int main()
{
    std::cout << "Hello World!" << std::endl;
    return 0;
}
END
        echo -e "${GREEN}/tmp/hello.cpp${NORMAL}"
        #g++ -v /tmp/hello.cpp 2> /tmp/hello.cpp.txt
        #g++ -v /tmp/hello.cpp
        #rm -rf /tmp/hello.cpp* a.out
    ;;
    go)
        cat << END > /tmp/hello.go
package main
import "fmt"
func main() {
    fmt.Println("Hello World!")
}
END
        echo -e "${GREEN}/tmp/hello.go${NORMAL}"
        #go build -o a.out /tmp/hello.go
        #rm -rf /tmp/hello.go a.out
    ;;
    py)
        cat << END > /tmp/hello.py
# -*- coding: UTF-8 -*-
print('Hello World!')
END
        echo -e "${GREEN}/tmp/hello.py${NORMAL}"
        #python /tmp/hello.py
        #rm -rf /tmp/hello.py
    ;;
    *)
        echo -e "${RED}Nothing to do!${NORMAL}"
    ;;
esac

