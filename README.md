# credential_fetcher

A Flutter Widget that gets Cookies from a webview and initiates a callback function

## Usage
url -> provide a url
callback -> a function that runs when cookies are obtained
loader -> a widget u can show while page is loading

CredentialFetcher(
        url: "https://www.instagram.com/accounts/login/",
        callback: (s) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyClass(text: s,),),);
        },
        loader: Center(
          child: CircularProgressIndicator(),
        )
