# Wowlist

A wordlist generation wrapper.

## Software Requirements

Developing wowlist required the following open-source software packages.

- figlet 2.2.5-3.1
- cewl 6.2.1-1

## Usage

This section will cover how to download and run the wowlist generator to your liking.

### Downloading

First, clone the repo:
```
git clone https://www.github.com/ntjennings1/wowlist.git
```

Be sure to give the file execution permissions (with admin privileges):
```
sudo chmod 744 $WOWLIST_HOME -R
```

Next, enter the directory of the wowlist project:
```
cd $WOWLIST_HOME
```

### Running

Once inside the coned directory, users can enter the following script to use wowlist features:
```
./src/wowlist.sh
```

### Parameters

Users must indicate valid parameters before obtaining a curated wordlist.

- [x] URL to grab words from
- [x] Minimum word length
- [x] Maximum crawl depth
- [x] Run duration

## Acknowledgements

```
Noah Jennings
	ntjennings1@gmail.com
	Old Dominion University
```
