package umka

import "core:os"
import "core:fmt"

printError :: proc(u: instance) {
	err := getError(u)
	fmt.printf("%s:%d:%d: %s\n", err.fileName, err.line, err.pos, err.msg)
}

defaultWarningCallback :: proc(err: ^error) {
	fmt.printf("%s:%d:%d: %s\n", err.fileName, err.line, err.pos, err.msg)
	os.exit(1)
}

