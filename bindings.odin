package umka

import "core:c"

foreign import umka "system:umka"

instance :: rawptr
funcCtx :: struct {
	entryOffset: c.int64_t,
	params: ^stackSlot,
	result: ^stackSlot,
}
stackSlot :: struct #raw_union {
  intVal: c.int64_t,
  uintVal: c.uint64_t,
  ptrVal: rawptr,
  realVal: c.double,
  real32Val: c.float,
} 
warningCallback :: proc(warning: ^error)
error :: struct {
	fileName: cstring,
  fnName: cstring,
  line, pos, code: c.int,
  msg: cstring,
}
externFunc :: proc(params, result: ^stackSlot)
hookEvent :: enum {
  UMKA_HOOK_CALL,
  UMKA_HOOK_RETURN,
}
hookFunc :: proc(fileName, funcName: cstring, line: c.int)
u_map :: struct {
	internal1, internal2: rawptr,
}
u_any :: struct {
	data, type: rawptr,
}

foreign umka {
	@(link_name="umkaAlloc")
	alloc :: proc"c"() -> instance ---
	@(link_name="umkaInit")
	init :: proc"c"(u: instance, fileName: cstring, sourceString: cstring, stackSize: c.int, reserved: rawptr, argc: c.int, argv: ^cstring, fileSystemEnabled: c.bool, implLibsEnabled: c.bool, warningCallback: warningCallback) -> c.bool ---
	@(link_name="umkaCompile")
	compile :: proc"c"(u: instance) -> c.bool ---
	@(link_name="umkaRun")
	run :: proc"c"(u: instance) -> c.int ---
	@(link_name="umkaCall")
	call :: proc"c"(u: instance, fn: ^funcCtx) -> c.int ---
	@(link_name="umkaFree")
	free :: proc"c"(u: instance) ---
	@(link_name="umkaGetError")
	getError :: proc"c"(u: instance) -> ^error ---
	@(link_name="umkaAlive")
	alive :: proc"c"(u: instance) -> c.bool ---
	@(link_name="umkaAsm")
	assembly :: proc"c"(u: instance) -> cstring ---
	@(link_name="umkaAddModule")
	addModule :: proc"c"(u: instance, fileName: cstring, sourceString: cstring) -> c.bool ---
	@(link_name="umkaAddFunc")
	addFunc :: proc"c"(u: instance, name: cstring, func: externFunc) -> c.bool ---
	@(link_name="umkaGetFunc")
	getFunc :: proc"c"(u: instance, moduleName: cstring, fnName: cstring, fn: ^funcCtx) -> c.bool ---
	@(link_name="umkaGetCallStack")
	getCallStack :: proc"c"(u: instance, depth: c.int, nameSize: c.int, offset: ^c.int, fileName: cstring, fnName: cstring, line: ^c.int) -> c.bool ---
	@(link_name="umkaSetHook")
	setHook :: proc"c"(u: instance, event: hookEvent, hook: hookFunc) ---
	@(link_name="umkaAllocData")
	allocData :: proc"c"(u: instance, size: c.int, onFree: externFunc) -> rawptr ---
	@(link_name="umkaIncRef")
	incRef :: proc"c"(u: instance, ptr: rawptr) ---
	@(link_name="umkaDecRef")
	decRef :: proc"c"(u: instance, ptr: rawptr) ---
	@(link_name="umkaGetMapItem")
	getMapItem :: proc"c"(u: instance, mapArg: u_map, key: stackSlot) -> rawptr ---
	@(link_name="umkaMakeStr")
	makeStr :: proc"c"(u: instance, str: cstring) -> cstring ---
	@(link_name="umkaGetStrLen")
	getStrLen :: proc"c"(str: cstring) -> c.int ---
	@(link_name="umkaMakeDynArray")
	makeDynArray :: proc"c"(u: instance, array: rawptr, type: rawptr, len: c.int) ---
	@(link_name="umkaGetDynArrayLen")
	getDynArrayLen :: proc"c"(array: rawptr) -> c.int ---
	@(link_name="umkaGetVersion")
	getVersion :: proc"c"() -> cstring ---
	@(link_name="umkaGetMemUsage")
	getMemUsage :: proc"c"(u: instance) -> c.int64_t ---
	@(link_name="umkaMakeFuncContext")
	makeFuncContext :: proc"c"(u: instance, closureType: rawptr, entryOffset: c.int, fn: ^funcCtx) ---
	@(link_name="umkaGetParam")
	getParam :: proc"c"(params: ^stackSlot, index: c.int) -> ^stackSlot ---
	@(link_name="umkaGetUpvalue")
	getUpvalue :: proc"c"(params: ^stackSlot) -> ^u_any ---
	@(link_name="umkaGetResult")
	getResult :: proc"c"(params, result: ^stackSlot) -> ^stackSlot ---
	@(link_name="umkaGetMetadata")
	getMetadata :: proc"c"(u: instance) -> rawptr ---
	@(link_name="umkaSetMetadata")
	setMetadata :: proc"c"(u: instance, metadata: rawptr) ---
}

