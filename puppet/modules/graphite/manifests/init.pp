class graphite {
  include apache
  include apache::mod::python

  include graphite::install
  include graphite::config
}