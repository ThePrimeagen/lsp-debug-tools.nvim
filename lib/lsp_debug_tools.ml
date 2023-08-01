let rec find_end_idx_of_json str idx count =
  if count = 0 then idx
  else if idx >= String.length str then raise Not_found
  else
    match str.[idx] with
    | '{' -> find_end_idx_of_json str (idx + 1) (count + 1)
    | '}' -> find_end_idx_of_json str (idx + 1) (count - 1)
    | _ -> find_end_idx_of_json str (idx + 1) count

let pluck_out_json line start =
  try
    let json_start = String.index_from line start '{' in
    let json_end = find_end_idx_of_json line (json_start + 1) 1 in

    if json_start = String.length line - 1 then "", String.length line
    else
      let json = String.sub line json_start (json_end - json_start) in
      json, json_end
  with Not_found -> line, String.length line

let print_out_jsons line =
    if line = "'" then ()
    else
        try
            let json, _ = pluck_out_json line 0 in
            let json = Yojson.Safe.from_string json in
            Printf.printf "%s\n" (Yojson.Safe.pretty_to_string json);
        with
        | Not_found -> Printf.printf "%s\n" line
        | Yojson.Json_error _ -> Printf.printf "    %s\n" line

let rec print_out_items list =
    match list with
    | [] -> ()
    | h :: t -> (
        print_out_jsons h;
        Printf.printf "\n";
        print_out_items t
    )

let filter_out_escaped line =
  Str.global_replace (Str.regexp "\\\\n") "\n" line |>
  Str.global_replace (Str.regexp "\\\\\\\\") "\\\\"

let pretty_list_print list =
  let level =
    if Str.string_match (Str.regexp "\\[ERROR\\]") (List.nth list 0) 0 then "E"
    else ""
  in

  if List.length list < 5 then
    Printf.printf "%s: %s\n" level (String.concat "\t" list)
  else
    let service = List.nth list 2 in
    let msg = List.nth list 4 |> filter_out_escaped in
    let msgs = String.split_on_char '\n' msg in

    Printf.printf "%s: %s\n" level service;
    print_out_items msgs;

    flush stdout;
    ()

let rec filter_list list filter =
  match filter with
  | None -> true
  | Some filtered_item -> (
      let filter_with_quotes = "\"" ^ filtered_item ^ "\"" in
      match list with
      | [] -> false
      | h :: t ->
          if h = filtered_item || h = filter_with_quotes then true
          else filter_list t filter)

let spawn file_name filter =
  let cmd = "tail -F " ^ file_name in
  let in_channel = Unix.open_process_in cmd in
  try
    while true do
      let line = input_line in_channel in

      let items = String.split_on_char '\t' line in
      if filter_list items filter then pretty_list_print items
    done
  with End_of_file ->
    Printf.printf "End of file\n";
    ignore (Unix.close_process_in in_channel)
