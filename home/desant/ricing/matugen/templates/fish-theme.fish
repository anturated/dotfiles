#!/usr/bin/env fish

# palette
set primary         {{colors.primary.default.hex_stripped}}
set on_primary      {{colors.on_primary.default.hex_stripped}}
set secondary       {{colors.secondary.default.hex_stripped}}
set tertiary        {{colors.tertiary.default.hex_stripped}}
set on_surface      {{colors.on_surface.default.hex_stripped}}
set on_surface_var  {{colors.on_surface_variant.default.hex_stripped}}
set outline         {{colors.outline.default.hex_stripped}}
set error           {{colors.error.default.hex_stripped}}
set on_error_cont   {{colors.on_error_container.default.hex_stripped}}
set on_tert_cont    {{colors.on_tertiary_container.default.hex_stripped}}
set primary_cont    {{colors.primary_container.default.hex_stripped}}
set surface         {{colors.surface.default.hex_stripped}}

# syntax
set --global fish_color_normal           $on_surface               # plain text
set --global fish_color_command          $primary          --bold  # echo, git, ls…
set --global fish_color_keyword          $on_error_cont    --bold  # if, for, while…
set --global fish_color_param            $on_surface               # bare arguments
set --global fish_color_option           $secondary                # -flags --flags
set --global fish_color_quote            $tertiary                 # "strings"
set --global fish_color_redirection      $secondary        --bold  # > >> |
set --global fish_color_end              $on_surface_var           # ; &
set --global fish_color_error            $error                    # syntax errors
set --global fish_color_comment          $outline          --italics
set --global fish_color_operator         $on_surface_var           # * ~ ?
set --global fish_color_escape           $on_tert_cont             # \n \x70
set --global fish_color_valid_path       $secondary        --underline
set --global fish_color_autosuggestion   $outline
set --global fish_color_history_current  $primary          --bold
set --global fish_color_match            --background=$primary_cont
set --global fish_color_selection        $surface --bold --background=$on_surface
set --global fish_color_search_match     $on_surface --background=$primary_cont
set --global fish_color_cancel           --reverse

# pager
set --global fish_pager_color_prefix               $primary --underline
set --global fish_pager_color_completion           $on_surface
set --global fish_pager_color_description          $on_surface_var  --italics
set --global fish_pager_color_progress             $secondary       --italics
set --global fish_pager_color_background           # transparent
set --global fish_pager_color_secondary_background # transparent
set --global fish_pager_color_secondary_prefix     $on_surface_var  --underline
set --global fish_pager_color_secondary_completion $on_surface_var
set --global fish_pager_color_secondary_description $outline        --italics
set --global fish_pager_color_selected_background  --background=$primary_cont
set --global fish_pager_color_selected_prefix      $on_primary      --underline
set --global fish_pager_color_selected_completion  $on_primary
set --global fish_pager_color_selected_description $on_surface_var  --italics
