# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

alias q = exit

$env.LS_COLORS = (
    "di=38;2;94;129;172:"
    + "fi=38;2;136;192;208:"
    + "ln=38;2;143;188;187:"
    + "ex=38;2;163;190;140:"
    + "or=38;2;191;97;106:"
    + "pi=38;2;235;203;139:"
    + "so=38;2;180;142;173:"
    + "bd=38;2;208;135;112:"
    + "cd=38;2;235;203;139:"
    + "su=38;2;191;97;106:"
    + "sg=38;2;235;203;139:"
    + "tw=38;2;136;192;208:"
    + "ow=38;2;129;161;193:"
    + "st=38;2;136;192;208"
)

$env.config = {
  show_banner: true
  buffer_editor: "nvim"
  float_precision: 2
  edit_mode: vi
  completions: {
    case_sensitive: false
    algorithm: "fuzzy"
    use_ls_colors: true
  }
  table: {
    mode: rounded
    index_mode: always
    show_empty: true
    padding: {
      left: 2
      right: 2
    }
  }
  ls: {
    use_ls_colors: true
  }
  cursor_shape: {
    vi_insert: line
    vi_normal: block
  }
  hooks: {
    env_change: {
      PWD: [
        { ||
            if (which direnv | is-empty) {
                return
            }
            direnv export json | from json | default {} | load-env
        }
      ]
    }
  }
  keybindings: [
    # vi insert mode
    {
      name: move_left
      modifier: control
      keycode: char_b
      mode: vi_insert
      event: { send: left }
    }
    {
      name: move_right
      modifier: control
      keycode: char_f
      mode: vi_insert
      event: {
        until: [
            { send: HistoryHintComplete }
            { send: right }
        ]
      }
    }
    {
      name: cut_line_to_end
      modifier: control
      keycode: char_k
      mode: vi_insert
      event: { edit: cuttoend }
    }
    {
      name: cut_line_from_start
      modifier: control
      keycode: char_u
      mode: vi_insert
      event: { edit: cutfromstart }
    }
    {
      name: move_left_backspace
      modifier: control
      keycode: char_h
      mode: vi_insert
      event: { 
        until: [
          { send: MenuLeft }
          { edit: Backspace }
        ]
      }
    }
    {
      name: move_right_complete_ghosttext
      modifier: control
      keycode: char_l
      mode: vi_insert
      event: {
        until: [
            { send: MenuRight }
            { send: ClearScreen }
        ]
      }
    }
    # vi normal mode
    {
      name: move_to_start
      modifier: shift
      keycode: char_h
      mode: vi_normal
      event: { send: ToStart }
    }
    {
      name: move_to_end
      modifier: shift
      keycode: char_l
      mode: vi_normal
      event: { send: ToEnd }
    }
    # all vi modes
    {
      name: accept_enter_with_ctrl_y
      modifier: control
      keycode: char_y
      mode: [vi_insert vi_normal]
      event: { send: enter }
    }
  ]
  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: columnar
        columns: 4
        col_padding: 2
      }
      style: {
        text: "#d8dee9"
        selected_text: { fg: "#eceff4" bg: "#5e81ac" attr: b }
        description_text: "#81a1c1"
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: "#d8dee9"
        selected_text: { fg: "#eceff4" bg: "#5e81ac" attr: b }
        description_text: "#88c0d0"
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: description
        columns: 4
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: "#d8dee9"
        selected_text: { fg: "#eceff4" bg: "#5e81ac" attr: b }
        description_text: "#a3be8c"
      }
    }
  ]
  color_config: {
    separator: "#4c566a"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#88c0d0" attr: "b" }
    empty: "#81a1c1"
    bool: "#88c0d0"
    int: "#b48ead"
    float: "#b48ead"
    filesize: "#88c0d0"
    duration: "#88c0d0"
    date: "#ebcb8b"
    range: "#ebcb8b"
    string: "#a3be8c"
    nothing: "#bf616a"
    binary: "#b48ead"
    cell_path: "#d8dee9"
    row_index: { fg: "#88c0d0" attr: "b" }
    record: "#88c0d0"
    list: "#88c0d0"
    block: "#81a1c1"
    hints: "#4c566a"
    search_result: { fg: "#2e3440" bg: "#ebcb8b" }
    shape_and: { fg: "#b48ead" attr: "b" }
    shape_binary: { fg: "#b48ead" attr: "b" }
    shape_block: { fg: "#81a1c1" attr: "b" }
    shape_bool: "#88c0d0"
    shape_closure: { fg: "#8fbcbb" attr: "b" }
    shape_custom: "#88c0d0"
    shape_datetime: { fg: "#ebcb8b" attr: "b" }
    shape_directory: "#88c0d0"
    shape_external: "#8fbcbb"
    shape_externalarg: { fg: "#a3be8c" attr: "b" }
    shape_external_resolved: "#8fbcbb"
    shape_filepath: "#88c0d0"
    shape_flag: { fg: "#81a1c1" attr: "b" }
    shape_float: { fg: "#b48ead" attr: "b" }
    shape_garbage: { fg: "#eceff4" bg: "#bf616a" attr: "b" }
    shape_glob_interpolation: { fg: "#8fbcbb" attr: "b" }
    shape_globpattern: { fg: "#88c0d0" attr: "b" }
    shape_int: { fg: "#b48ead" attr: "b" }
    shape_internalcall: { fg: "#88c0d0" attr: "b" }
    shape_keyword: { fg: "#81a1c1" attr: "b" }
    shape_list: { fg: "#88c0d0" attr: "b" }
    shape_literal: "#81a1c1"
    shape_match_pattern: "#a3be8c"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#bf616a"
    shape_operator: "#ebcb8b"
    shape_or: { fg: "#b48ead" attr: "b" }
    shape_pipe: { fg: "#b48ead" attr: "b" }
    shape_range: { fg: "#ebcb8b" attr: "b" }
    shape_raw_string: { fg: "#a3be8c" attr: "b" }
    shape_record: { fg: "#88c0d0" attr: "b" }
    shape_redirection: { fg: "#b48ead" attr: "b" }
    shape_signature: { fg: "#a3be8c" attr: "b" }
    shape_string: "#a3be8c"
    shape_string_interpolation: { fg: "#8fbcbb" attr: "b" }
    shape_table: { fg: "#81a1c1" attr: "b" }
    shape_variable: { fg: "#b48ead" attr: "i" }
    shape_vardecl: { fg: "#b48ead" attr: "u" }
  }
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
source ~/.zoxide.nu
