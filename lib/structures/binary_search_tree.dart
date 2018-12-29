class BinarySearchTree<T> {
  BSTNode<T> root;
  int size;

  BinarySearchTree() {
    size = 0;
  }

  /// Inserts a node into the correct position in the tree
  void insert(T item) {
    BSTNode node = BSTNode(value: item);
    if(size == 0) root = node;
    else root.insert(node);

    size++;
  }

  /// Returns the nodes' values in order by performing an in order traversal
  List<T> inOrder() {
    return root.inOrder();
  }
}

class BSTNode<T> {
  T value;
  BSTNode<T> left;
  BSTNode<T> right;
  
  BSTNode({this.value, this.left, this.right});

  void insert(BSTNode item) {
    if(item.value <= this.value) {
      this.left == null ? this.left = item : this.left.insert(item);
    } else {
      this.right == null ? this.right = item : this.right.insert(item);
    }
  }

  List<T> inOrder() {
    List<T> ret = List<T>();
    if(this.left != null) ret.addAll(this.left.inOrder());
    ret.add(this.value);
    if(this.right != null) ret.addAll(this.right.inOrder());
    return ret;
  }
}