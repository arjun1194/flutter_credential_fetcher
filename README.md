# credential_fetcher

A Flutter Widget that gets Cookies from a webview and initiates a callback function

## Usage

CredentialFetcher(
        url: "https://www.instagram.com/accounts/login/",
        callback: (s) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyClass(text: s,),),);
        },
        loader: Center(
          child: CircularProgressIndicator(),
        )
