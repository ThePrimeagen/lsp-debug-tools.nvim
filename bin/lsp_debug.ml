open Core

let () =
  Printf.printf "Hello world\n";
  let filename_param =
    let open Command.Param in
    anon ("filename" %: string)
  in

  let name_param =
    let open Command.Param in
    flag "--name" (optional string) ~doc:"the name of the server to filter on"
  in

  let command =
    Command.basic
      ~summary:"Tails an lsp log file that uses structured_logging rust library"
      ~readme:(fun () -> "More detailed information")
      (Command.Param.map2 filename_param name_param
         ~f:(fun filename name_opt () ->
           Lsp_debug_tools.spawn filename name_opt))
  in

  let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command in

  ()
