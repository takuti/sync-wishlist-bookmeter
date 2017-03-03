Wishlist/pre-list Synchronizer
===

Bookmeter http://bookmeter.com/ is one of the most popular reading support web services in Japan. Our synchronizer sync its *pre-list* (list of books what a user wants to read) with Amazon's wishlist.

## Installation

```
$ gem install nokogiri
$ gem install mechanize
$ git clone git@github.com:takuti/sync-wishlist-bookmeter.git
```

To save bookmeter's login info on local, we can use [direnv](https://github.com/direnv/direnv). It can be installed as:

```
$ brew install direnv
```

After the above command, write `.envrc` file as follows,

```sh
export BOOKMETER_MAIL=your@email.com
export BOOKMETER_PASSWORD=pAsswOrd
export WISHLIST_URL=https://www.amazon.co.jp/gp/registry/wishlist/18KSCRB1ZR3W
```

and place it under the project root directory. Importantly, **the wishlist must be public**.

Finally,

```
$ direnv allow
```

activates the environment.

## Usage

```
$ ruby synchronizer.rb
```


## License

MIT
