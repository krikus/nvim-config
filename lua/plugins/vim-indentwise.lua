-- [- : Move to previous line of lesser indent than the current line.
-- [+ : Move to previous line of greater indent than the current line.
-- [= : Move to previous line of same indent as the current line that is separated from the current line by lines of different indents.
-- ]- : Move to next line of lesser indent than the current line.
-- ]+ : Move to next line of greater indent than the current line.
-- ]= : Move to next line of same indent as the current line that is separated from the current line by lines of different indents.
return {
  "jeetsukumaran/vim-indentwise",
  lazy = false,
}
