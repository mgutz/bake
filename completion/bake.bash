_bake()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local opts=$(bake --tasks)

    COMPREPLY=( $(compgen -W "${opts[*]}" -- $cur) )
}
complete -F _bake bake

# vim: set filetype=sh :
