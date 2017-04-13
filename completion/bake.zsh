#compdef bake
opts=$(bake --tasks)
_arguments "1:option:($opts)" '::param:_files'

# vim: set filetype=sh :
