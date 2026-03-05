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
	alloc :: proc() -> instance ---
	@(link_name="umkaInit")
	init :: proc(u: instance, fileName: cstring, sourceString: cstring, stackSize: c.int, reserved: rawptr, argc: c.int, argv: ^cstring, fileSystemEnabled: c.bool, implLibsEnabled: c.bool, warningCallback: warningCallback) -> c.bool ---
	@(link_name="umkaCompile")
	compile :: proc(u: instance) -> c.bool ---
	@(link_name="umkaRun")
	run :: proc(u: instance) -> c.int ---
	@(link_name="umkaCall")
	call :: proc(u: instance, fn: ^funcCtx) -> c.int ---
	@(link_name="umkaFree")
	free :: proc(u: instance) ---
	@(link_name="umkaGetError")
	getError :: proc(u: instance) -> ^error ---
	@(link_name="umkaAlive")
	alive :: proc(u: instance) -> c.bool ---
	@(link_name="umkaAsm")
	assembly :: proc(u: instance) -> cstring ---
	@(link_name="umkaAddModule")
	addModule :: proc(u: instance, fileName: cstring, sourceString: cstring) -> c.bool ---
	@(link_name="umkaAddFunc")
	addFunc :: proc(u: instance, name: cstring, func: externFunc) -> c.bool ---
	@(link_name="umkaGetFunc")
	getFunc :: proc(u: instance, moduleName: cstring, fnName: cstring, fn: ^funcCtx) -> c.bool ---
	@(link_name="umkaGetCallStack")
	getCallStack :: proc(u: instance, depth: c.int, nameSize: c.int, offset: ^c.int, fileName: cstring, fnName: cstring, line: ^c.int) -> c.bool ---
	@(link_name="umkaSetHook")
	setHook :: proc(u: instance, event: hookEvent, hook: hookFunc) ---
	@(link_name="umkaAllocData")
	allocData :: proc(u: instance, size: c.int, onFree: externFunc) -> rawptr ---
	@(link_name="umkaIncRef")
	incRef :: proc(u: instance, ptr: rawptr) ---
	@(link_name="umkaDecRef")
	decRef :: proc(u: instance, ptr: rawptr) ---
	@(link_name="umkaGetMapItem")
	getMapItem :: proc(u: instance, mapArg: u_map, key: stackSlot) -> rawptr ---
	@(link_name="umkaMakeStr")
	makeStr :: proc(u: instance, str: cstring) -> cstring ---
	@(link_name="umkaGetStrLen")
	getStrLen :: proc(str: cstring) -> c.int ---
	@(link_name="umkaMakeDynArray")
	makeDynArray :: proc(u: instance, array: rawptr, type: rawptr, len: c.int) ---
	@(link_name="umkaGetDynArrayLen")
	getDynArrayLen :: proc(array: rawptr) -> c.int ---
	@(link_name="umkaGetVersion")
	getVersion :: proc() -> cstring ---
	@(link_name="umkaGetMemUsage")
	getMemUsage :: proc(u: instance) -> c.int64_t ---
	@(link_name="umkaMakeFuncContext")
	makeFuncContext :: proc(u: instance, closureType: rawptr, entryOffset: c.int, fn: ^funcCtx) ---
	@(link_name="umkaGetParam")
	getParam :: proc(params: ^stackSlot, index: c.int) -> ^stackSlot ---
	@(link_name="umkaGetUpvalue")
	getUpvalue :: proc(params: ^stackSlot) -> ^u_any ---
	@(link_name="umkaGetResult")
	getResult :: proc(params, result: ^stackSlot) -> ^stackSlot ---
	@(link_name="umkaGetMetadata")
	getMetadata :: proc(u: instance) -> rawptr ---
	@(link_name="umkaSetMetadata")
	setMetadata :: proc(u: instance, metadata: rawptr) ---
}

