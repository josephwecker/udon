%%{
  machine foo;
  write data;
}%%

%%{
  main := [#] [ \t]* [^\n]+ [\n];

  write init;
  write exec;
}%%
