function() {
  return function() {
    return 'user_' + new Date().getTime() + '@mail.com';
  }
}