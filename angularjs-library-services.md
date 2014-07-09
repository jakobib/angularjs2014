---
title: Exposing library services with AngularJS
author:
    - Jakob Voß
    - Moritz Horn
date: 2014-07-11
nocite: |
    @ngmodules
...

This article provides an introduction to the JavaScript framework AngularJS and
specific AngularJS modules for accessing library services. It shows how
information such as search suggestions, additional links, and availability
can be embedded in any website. The ease of reuse may encourage more libraries
to expose their services via standard APIs to allow usage in different context.

# Introduction

The demand to open up library systems through web services has been known since
years [@Breeding2009]. In particular service-oriented architecture (SOA)
promised to better allow a continuous evolution of library automation and to
better connect with external systems. Nevertheless current library systems are
rarely build of loosely coupled parts that could be used independently.
The background of this abidance on monolithical systems must be discussed
elsewhere. One reason might be a lack of motivation to provide library
services via open APIs.

## Library services and APIs

Services provided by a library or similar institution should be easy to use by 
anyone and in any form. Most services, however, can only be used in the fixed
context of a particular user interface. If a service can be accessed via
application programming interface (API), it can also be integrated and used
in other applications. Nevertheless there is a lack of motivation to expose
services via open APIs.

User interfaces are curated and revised by usability studies
and user experience (UX) at best. In other instances the UI is simply judged
with common sense by normal library staff and management. 
APIs on the other hand, cannot simply be viewed,
used, and judged by anyone. Unlike the UI, an API is not a final application to
make use of a service, but the basis for creation of service applications:
Without APIs, applications are difficult to build and services can only be
provided in limited form. Without applications, however, it is difficult to
justify the need for an API.

To give an example, most library systems lack an API to query current 
availability of documents held by the library. As long as information about 
current availability was only displayed in local library OPACs there was little
motivation to create a public API. With the need to display availability
information in discovery interfaces such as VuFind, the Document Availability 
Information API ([DAIA]) was specified and implemented at GBV [@DAIA]. But 
little interest was shown by other libraries and system vendors as long as they 
did not require the API for internal use. The full benefit of an open API is not 
revealed until different applications by different parties make use of it. This
article will demonstrate a possible strategy to increase visibility and use of 
library APIs by providing client modules that facilitate the creation of 
applications by third parties. The modules are based on the JavaScript 
framework AngularJS which is getting more and more popular among developers
of web applications. The general strategy is illustrated in the following
diagram:

![From library service to web application](layers.png)

# AngularJS

[AngularJS] is a web application framework that aims to enhance the
functionality of JavaScript. The framework is designed to support
modularization on multiple levels. Functionality of applications is broken into
parts that can be tested and reused independently. 

Application logic is first grouped in *modules*, each included with an HTML
`<script>` tag. Some popular modules are listed at the inofficial directory
<http://ngmodules.org/>. Modules may build on each other and define
*directives*. These directives can be used in form of custom HTML tags and
attributes ("declarative HTML"). The core AngularJS module contains directives
for basic programming syntax in HTML, such as conditionals (`ng-if`) and loops
(`ng-repeat`), among others. This extension of HTML is further enriched to a a
template syntax with AngularJS *expressions* written in curly brackets
(`{{}}`). The most common use of these expression is to dynamically display
variables in HTML templates. In contrast to most other template systems,
variables are bound two-way: the display is updated automatically when a
variable is changed, and changes of the HTML document (e.g. by input forms) are
reflected in the JavaScript variables. Part of modularization, variables are
limited to *scopes* that act like namespaces in other programming languages.

The following example illustrates the use of AngularJS with scope variables,
templates, and directives:^[All examples are available also as part of the
article's code repository at <http://github.com/jakobib/angularjs2014/>.]

```{.html}
<html ng-app="myApp">
 <head>
  <script src="angular.min.js"></script>
  <script>
    angular.module('myApp', []);
    function MyController($scope) {
      $scope.books = [
        { title: "One Thousand and One Nights" },
        { title: "Where the Wild Things Are", author: "Sendak" },
        { title: "The Hobbit", author: "Tolkien" },
      ];
    }
  </script>
 </head>
 <body ng-controller="MyController">
  <ul ng-repeat="b in books | orderBy:'title'">
   <li>
    <i>{{b.title}}</i>
    <span ng-if="b.author">by {{b.author}}</span>
   </li>
  </ul>
 </body>
</html>
```

The example consists of an application module "myApp". This module defines a
controller "MyController" to set a list of three bibliographic items in the
variable "books" of a given scope. The controller is later used in the HTML
body to display a sorted list of books with an HTML template. The template
makes use of standard AngularJS directives (`ng-repeat`, `ng-if`) and
expressions (`| orderBy:'title'`, `b.title`, `b.author`). The application logic
to create such a list could also be packed in a new directive to be used as
"widget" at multiple places.

# Modules for embedding library services

The practical embedding of library services in websites with AngularJS is
illustrated in the following with two examples. Both are available as AngularJS
modules for easy reuse: the *ng-suggest* module provides access to search 
suggestions and links [@ngsuggest] and the *ng-daia* module provides access to
availability information [@ngdaia]. Both modules are hosted in public git 
repositories with API documentation, examples, and downloads 
(<http://gbv.github.io/ng-suggest/> and <http://gbv.github.io/ng-daia/>).

## Suggestions with ng-suggest

The OpenSearch standard for search engines includes a specification for how to 
query search suggestions and autocomplete services via HTTP [@Clinton2006].
Suggestion services are provided by many search applications as "typeahead".
The method can also be used for instance by recommendation services [@Voss2008] 
and to support support tagging with controlled vocabularies [@Nagaya2011].

![Typeahead via OpenSearch Suggestions](typeahead.jpg)

The OpenSearch Suggestions specification defines a query response as JSON array
with at least two elements (query string and a list of search completions):

    [
        "Moz",
        ["mozilla","mozilla firefox","mozart","mozilla thunderbird",...]
    ]

Optional elements can include descriptions and URLs for each search completion.
While processing of this simple format is not very complex, it still requires
JavaScript skills to make use of a suggestion service. *ng-suggest* simplifies
the embedding to two HTML statements. The following example code adds Wikipedia 
typeahead features to an input form element:

```{.html}
<html ng-app="myApp">
    <link href="bootstrap.min.css" rel="stylesheet" />
    <script src="angular.min.js"></script>
    <script src="ui-bootstrap-tpls.min.js"></script>
    <script src="ng-suggest.min.js"></script>
    <script>
    angular.module('myApp', ['ui.bootstrap','ngSuggest']);
    function MyController($scope){
        $scope.api = 
            "https://en.wikipedia.org/w/api.php?action=opensearch&limit=10&namespace=0&format=json&search=",
        $scope.selectItem = function(item) {
            $scope.item = item;
        };
    };
    </script>
    <body ng-controller="MyController">
    <input style="width:400px" class="form-control"
        typeahead-on-select="selectItem($item)"
        ng-model="input"
        suggest-typeahead="api" jsonp=1
        placeholder="Search Wikipedia"
    />
    {{item}}
    ...
    
  </body>
</html>
```

The resulting HTML page looks like the following figure:

![Suggest Wikipedia articles with ng-suggest](suggest_wikipedia_en.png)

Similar suggestions can be provided for any Open Search Suggestions service
by just changing the service's base URL. Among other features, responses can be
embedded as simple lists (SeeAlso recommender services, for instance related 
documents and related publications), and different JSON response formats can 
be mapped from.

## Availability with ng-daia

DAIA defines a data model and an HTTP API for accessing information about the
current availability of documents. Its aim is to provide a way for libraries to
allow open and easy-to-use access to holding information from their catalogs.
This, in turn, enables the inclusion of document availability information in
external applications and websites (catalogs, reference management, e-learning
platforms etc.). Among other formats, DAIA provides
availability information in JSON, the first choice for web applications written
in JavaScript. The AngularJS module *ng-daia* implements client code to execute
and process a DAIA query and to display holding information in convenient form.
The integration into HTML is exemplarily documented in the following code: 

```{.html}
<html ng-app="myApp">
 <head>
  <script src="angular.min.js"></script>
  <script src="ng-daia.min.js"></script>
  <script>angular.module('myApp', ['ngDAIA']);</script>
  <link href="ng-daia.css" rel="stylesheet" />
 </head>
 <body>
  <div daia-api="//daia.gbv.de/" 
       daia-id="opac-de-ma9:ppn:685460711">
  </div>
 </body>
</html>
```

The *ng-daia* module provides a directive (`daia-api`) to query a DAIA service
with a given document identifier (`daia-id`). The recieved DAIA response is then
fed to a customizable AngularJS template, resulting in the following display: 

![Full availability view with ng-daia default template](ngdaia_demo_EN_full.png)

The full availability view as implemented in the default templates of *ng-daia*
reflects the nested structure of DAIA data model, consisting of an outer layer
for institutional and general document information and displays for particular
document holdings [@DAIA]. The default template of directive `ng-api` uses
another directive for display of holding item (`daia-item`) and its item 
template can be customized as well. Another directive is provided for most
compact display (`daia-simple`, see figure 5). DAIA Simple is a flattened,
aggregated form of availability information that covers typical use cases,
such as short display in a result list [@DAIA, section 6.1]. The *ng-daia* 
module includes functions to transform from full DAIA to DAIA simple as well.

![Minimal availability view with daia-simple](ngdaia_demo_EN_simple.png)

All templates included in *ng-daia* can be customized with CSS. Localization 
for display in other languages is already supported with the popular module 
[angular-translate] [@angular-translate]. Thanks to two-way binding of 
AngularJS variables, a simple statement such as `$scope.language = 'de'` can
be enough to update the full availability display in another language.

# Conclusions

*This section is still being written*

...
Utilizing this tool will allow website creators to easily embedd either current
information concerning a specific document, or providing a way to request
availability information from multiple sources.
...

AngularJS modules, such as *ng-suggest* and *ng-daia* presented above, provide an
easy method to integrate library services in websites and applications. A basic
prequisite to support use of a library service, however, is the availability of
an HTTP-based API to this service. Despite existing efforts to open library
systems (e.g. the [ILS-DI
Recommendations](http://old.diglib.org/architectures/ilsdi/) and [WorldCat Web
Services](www.oclc.org/developer/webservices)) the support of standard APIs in
library systems is non-satisfying. Apart from search via SRU and resource
synchronization via OAI-PMH, most library services are not provided via an API
at all, or the API is specific to the underlying library system only, or it is
very complex and only available for internal use (e.g. NCIP). The lack of
available APIs, however, is not a technical problem but a problem of motivation
to specify, implement, provide, and document these APIs. The examples of how to
integrate library services in arbitrary web applications, given in this
article, may at least add some motivation to provide library services via open
APIs.

Even if AngularJS is or will not be the technology of your choice, the
principle illustrated in the initial diagram above makes sense. Libraries
should not only expose their services via openly specified APIs but also
provide client libraries to facilitate the integration of these services into
web applications. To minimize the work of doing so, one should build on
standardized APIs instead of (re)inventing new APIs for every library system.

*...lessons learned: development of an API and an API client as AngularJS module
is fruitful...*

Candidates for most missing AngularJS modules to access library services: SRU
and/or OpenSearch (see http://dlib.org/dlib/july10/hammond/07hammond.html for a
description/example of both).

*...If no common API exists, one must specify one...  for instance at GBV we are
evaluating APIs to access controlled vocabularies expressed in SKOS (ng-skos)...*

*...some final words...*

---

*Notes maybe to include in the article text:*

A third example can be found as work in progress at <https://github.com/gbv/ng-skos>. **ng-skos** is a module to interact with authority files and other simple
knowledge organisation systems (SKOS).

As is the philosophy of AngularJS easily implementable and reusable solution to this problem. It retrieves the suggestions of a specified service and, using the [Bootstrap UI](http://angular-ui.github.io/bootstrap/), provides a typeahead function for web applications.

How can the vicious circle of missing APIs to library services be broken?

(this article is based on
the assumption that libraries actually want to facilitate the use of their
servics. In some cases this assumption might be wrong).

an easy way how library services, if available in form of APIs, 
can be exposed, used and integrated into other web applications.

---

[DAIA]: http://purl.org/NET/DAIA
[AngularJS]: https://angularjs.org/
[angular-translate]: http://angular-translate.github.io/

# References
