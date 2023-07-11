enum  ServicePath {
  invoices, users;

  String urlString() {
    switch (this) {
      case ServicePath.invoices:
        return 'https://borderless-mobile-test-default-rtdb.firebaseio.com/invoices.json';
      case ServicePath.users:
        return 'https://borderless-mobile-test-default-rtdb.firebaseio.com/users.json';
    }
  }
}

class ServiceException implements Exception {
  @override
  String toString() {
    return 'Server Error';
  }
}

class ImplementationException implements Exception {
  @override
  String toString() {
    return 'Abstract class is not implemented';
  }
}