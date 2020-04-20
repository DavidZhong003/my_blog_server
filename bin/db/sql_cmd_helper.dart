String query({
  String tableName,
  List<String> columns,
}) {
  String columnsString;
  if(columns==null||columns.isEmpty){
    columnsString = '*';
  }else{
    columnsString = columns.toString();
  }
  return 'select $columnsString from $tableName';
}
