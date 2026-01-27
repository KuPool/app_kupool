bool isNotEmpty(List? list) {
  return list != null && list.isNotEmpty;
}

bool isEmpty(List? list) {
  return list == null || list.isEmpty;
}
bool isValidString(String? str) {
  return str != null && str.isNotEmpty;
}
bool isUnValidString(String? str) {
  return str == null || str == "";
}