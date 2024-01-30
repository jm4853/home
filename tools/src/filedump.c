#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>

char *binStr(int);

/*
 * SPECS:
 * Default: Print both binary and hex representation of stdin
 * Flags:
 *  -x Hex only
 *  -b Bin only
 *  -n Num lines
 */

#define LINE_BYTES 8
// 64 for bin representation of bytes
// 16 for hex representation of bytes
// 2 for padding inbetween bin and hex
// 64 + 16 + 2 = 83
#define LINE_CHARS 83


char *keys = "0123456789ABCDEF";

char
nibToHex(char nib) {
// printf("Got nib: %s\n", binStr(nib));
    return keys[(uint8_t)nib];
}

int
main(int argc, char *argv[]) {
    // + 1 for newline
    unsigned char line[LINE_CHARS + 1];
    unsigned char buf[LINE_BYTES];
    int n, i, j, hex_offset, num_lines, h;
    int fd;

    num_lines = -1;
    h = 1;

    for (i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
            fd = open(argv[i], O_RDONLY);
            if (fd < 1) {
                perror("open");
                exit(1);
            }
            close(0);
            dup(fd);
            close(fd);
        }
        else {
            if (argv[i][1] == 'n' && i + 1 < argc) {
                num_lines = atoi(argv[i + 1]);
                if (num_lines < 1) {
                    fprintf(stderr, "Invalid number of lines\n");
                    exit(1);
                }
                i++;
            } else if (argv[i][1] == 'b') {
                h = 0;
            }
        }
    }

    for (i = 0; i < LINE_CHARS; i++) line[i] = ' ';
    line[LINE_CHARS] = '\n';
    hex_offset = LINE_CHARS - (LINE_BYTES * 2);

    while (num_lines) {
        n = read(0, buf, LINE_BYTES);

        if (n < 1) break;

        for (i = 0; i < LINE_BYTES; i++) {
            if (i >= n) {
// printf("Line end case\n");
                for (j = 0; j < 8; j++) line[(8 * i) + j] = '.';
                line[hex_offset + (2 * i)] = '.';
                line[hex_offset + (2 * i) + 1] = '.';
                continue;
            }
            // Iterate through each bit in the ith byte of the read
            // and check if its a 1 or 0
            for (j = 0; j < 8; j++) {
                if (buf[i] & (1<<(7 - j))) line[(8 * i) + j] = '1';
                else line[(8 * i) + j] = '0';
                // line[(8 * i) + j] = (buf[i] & (128 >> j)) ? '1' : '0';
            }
// printf("Byte: %s\n", binStr(buf[i]));
            if (h) {
                // First half of byte
                line[hex_offset + (2 * i)] = nibToHex(buf[i] >> 4);
                // Second half of byte
                line[hex_offset + (2 * i) + 1] = nibToHex(buf[i] & 0x0F);
            }
        }
        write(1, line, LINE_CHARS + 1);
        if (num_lines != -1) num_lines--;
    }

    return 0;
}

char *binStr(int n) {
    int i;
    char *s;
    s = calloc(9, 1);
    for (i = 0; i < 8; i++) {
        if (n >> i & 1) {
            s[7 - i] = '1';
        } else {
            s[7 - i] = '0';
        }
    }
    return s;
}
