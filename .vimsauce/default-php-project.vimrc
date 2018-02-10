let g:current_dir = "/home/ike/path-to-default-php-project"
exec 'cd ' . g:current_dir

let g:vdebug_options["port"] = 9000
let g:vdebug_options["path_maps"] = {'/phpapp': '/home/ike/path-to-default-php-project'}

NERDTree
