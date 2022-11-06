project('thing', 'c')

thing_sources = [
  'lib/meta.c',
  'lib/map.c',
  'lib/minilua.h',
  'lib/std_image.h',
  'lib/sokol_app.h',
  'lib/sokol_gfx.h',
  'lib/sokol_glue.h',
  'lua.c',
  'main.c',
  'meshbox.h',
  'shader.h'
]

thing_deps = [
  dependency('egl'),
  dependency('gl'),
  dependency('x11'),
  dependency('xcursor'),
  dependency('xi'),
]

add_global_arguments('-DSOKOL_GLES2', language : 'c')
add_global_arguments('-DSOKOL_FORCE_EGL', language : 'c')

thing = executable('thing', thing_sources,
  dependencies: thing_deps,
  include_directories: './lib')