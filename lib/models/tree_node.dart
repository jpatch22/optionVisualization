class TreeNode {
  final String value;
  List<TreeNode> children = [];

  TreeNode(this.value);

  @override
  String toString() {
    return "Value: $value || children: $children";
  }
}
