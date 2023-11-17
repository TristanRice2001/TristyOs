void printf(char *string);

const int BASE_VID_MEM = 0xb8000;
const int NUM_TERMINAL_COLS = 80;
const int NUM_TERMINAL_ROWS = 25;
char *video_ptr = (char *)BASE_VID_MEM;

void put_newline() {
	int curr_vid_position = (int) video_ptr;
	int curr_text_offset = curr_vid_position - BASE_VID_MEM;
	// there are two bytes for every character on the screen
	int bytes_per_row = NUM_TERMINAL_COLS * 2;
	int bytes_left_in_current_row = bytes_per_row - (curr_text_offset % bytes_per_row);
	video_ptr += bytes_left_in_current_row;
}

void putchar(char character) {
	*(video_ptr + 0) = character;
	*(video_ptr + 1) = 'a';
	*(++video_ptr);
	*(++video_ptr);
}

void put(char character) {
	if (character == '\n') {
		put_newline();
	} else {
		putchar(character);
	}
}

void printptr(void *p) {
	char * digits = "0123456789abcdef";

	long init = (long) &p;
    char character;

	int digits_arr[10];
	int i = 0;

    while (init) {
		digits_arr[i++] = init & 0x0000000F;
        // long character = init & 0x0000000F;
        init >>= 4;
    }
	printf("0x");
	while (i) {
		put(digits[digits_arr[i]]);
		i--;
	}
}

void printint(int n) {
	// all ascii digits start at 48 (i.e, character '0' is 48, '1' is 49, etc)
	const int ascii_digits_start = 48;

	// 10 is the maximum number of digits in a 32 bit integer
	int digits_arr[10];
	int i = 0;

	while (n > 10) {
		digits_arr[i++] = n % 10;
		n /= 10;
	}

	putchar((char) n + ascii_digits_start);
	while (i--) {
		int ascii_num = digits_arr[i] + ascii_digits_start;
		putchar((char) ascii_num);	
	}
}

void printf(char *string) {
	int i = 0;
	while (string[i] != 0x00) {
		put(string[i]);
		i++;
	}
}
