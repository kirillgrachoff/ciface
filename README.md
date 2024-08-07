# ciface
Library for random success/fail emoji

# Library Installation
- Install the package
```bash
zig fetch --save git+https://github.com/kirillgrachoff/ciface
```
- Add the package in `build.zig`
```zig
const ciface = b.dependency("ciface", .{});
exe.root_module.addImport("ciface", cham.module("ciface"));
```
- Import in your project
```zig
const ciface = @import("ciface");
```

# Usage
```zig
var rand: std.Random = ...;
ciface.getSuccess(rand) // -> Happy face
ciface.getFail(rand)    // -> Sad face

ciface.faces.success // happy faces
ciface.faces.fail    // sad faces
```

# Binary
```bash
./ciface
```

## `NO_COLOR` support
This binary supports [`NO_COLOR`](https://no-color.org/)
