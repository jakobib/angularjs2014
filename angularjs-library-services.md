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
Information API (DAIA) was specified and implemented at GBV [@DAIA]. But little
interest was shown by other libraries and system vendors as long as they did
not require the API for internal use. The full benefit of an open API is not 
revealed until different applications by different parties make use of it. This
article will demonstrate a possible strategy to increase visibility and 
use of library APIs by providing client modules that facilitate the creation
of applications by third parties. The modules are based on the JavaScript
framework AngularJS which is getting more and more popular among developers
of web applications. The general strategy is illustrated in the following
diagram:

![From library service to web application](layers.png)

# AngularJS

Similar to

*general overview of AngularJS (how it works, strength, alternatives...)*

As one of several frameworks, [AngularJS](https://angularjs.org/) aims to enhance the functionality of JavaScript, specifically by providing features supporting modularisation and testing. Structurally, the framework is based on "modules", which contain the server-side logic and have to be included via an HTML `<script>`-tag.

```
<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.13/angular.min.js"></script>
``` 

The first tool for facilitating usability is the promotion of discrete submodules, in which different behaviors can be defined seperately of each other. These "directives" can then be easily reused on their own in different applications. They are also a tool for seperating server side logic from client views, accomplished through a practical template solution. AngularJS supports the inclusion of html-code via those templates, which can be assigned unique scopes - again to promote the reduction of dependencies. Combined with this functionality, the framework provides built-in two-way data binding. This in turn adds a lot of options for HTML coding, like the possibility to display variable values, automatically updated during runtime (Angular provides its curly bracket `{{}}` syntax to this end). Furthermore, AngularJS provides modules for including basic programming syntax into HTML, like if-prompts or loops (`ng-if` and `ng-repeat`, respectively), which can simply be used as parameters. For example,

```
<html ng-app="myApp">
<head>
<script src="angular.min.js"></script>
<script>
    angular.module('myApp', []);
    function MyController($scope){
        $scope.data = [
            { id: "123", value: "foo" },
            { id: "345", value: "bar" },
            { value: "text" }
        ]
    }
</script>
</head>
<body ng-controller="MyController">
    <ul ng-repeat="d in data">
        <li ng-if="d.id">{{d.value}}</li>
    </ul>
    ...
</html>
```

will display every index-item `value` of the `data` scope, if the subfield `data.id` exists for the specific item. So `foo` and `bar` would be added to the list. Combined with the option to reuse other prebuilt modules, this greatly enriches the possibilities of DOM-manipulation. A lot of useful modules can be found at <http://ngmodules.org/>.

# Modules for embedding library services

The practical embedding of library services in websites with AngularJS is
illustrated in the following with two examples. Both are available as AngularJS
modules for easy reuse: the ng-suggest module provides access to search 
suggestions and links [@ngsuggest] and the ng-daia module provides access to
availability information [@ngdaia].


A third example can be found as work in progress at <https://github.com/gbv/ng-skos>. **ng-skos** is a module to interact with authority files and other simple
knowledge organisation systems (SKOS).

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
JavaScript skills to make use of a suggestion service. ng-suggest simplifies
the embedding to two HTML statements. The following example enriches an input
form with typeahead from Wikipedia as depicted in the figure below:

```
TODO (HTML to reproduce the image)
```

![Suggest Wikipedia articles with ng-suggest](suggest_wikipedia_en.png)

Similar suggestions can be provided for any Open Search Suggestions service
by just changing the service's base URL. Among other features, responses can be
embedded as simple lists (for instance related documents and related 
publications), and different JSON response formats can be mapped.

## Availability with ng-daia

The [Document Availability Information API
(DAIA)](http://www.gbv.de/wikis/cls/DAIA_-_Document_Availability_Information_API)
defines a data model and an HTTP API for accessing information about the
current availability of documents. Its aim is to provide a way for libraries to
allow open and easy-to-use access to holding information from their catalogs.
This, in turn, enables the inclusion of document availability information in
external applications and websites. Among other formats, DAIA provides
availability information in JSON, the first choice for web applications written
in JavaScript. The AngularJS module ng-daia implements client code to execute
and process a DAIA query and to display holding information in convenient form.
The integration into HTML is exemplarily documented in the following code: 

```
<html ng-app="myApp">
<head>
  <script src="angular.min.js"></script>
  <script src="ng-daia.min.js"></script>
  <script>angular.module('myApp', ['ngDAIA']);</script>
  <link href="ng-daia.css" rel="stylesheet" />
</head>
<body>
  <div daia-api="http://your-daia-base-url" daia-id="your-document-id">
  </div>
</body>
</html>
```

ng-daia is hosted in a public git repository, documented and downloadable at
<http://gbv.github.io/ng-daia/>. The module utilizes its directives to query a
DAIA server and transform the received object to control the displaying of
specific parts of information. To achieve a compact structure, there are
different directives for the response as a whole, a single item of the result
and the information concerning its current availability. The availability of
documents in DAIA is split into several independent services (openaccess, loan,
interloan and presentation), which can be reflected in the implementation.
Furthermore, `daia-simple` defines an additional format provided by this
module, providing the most preferable status for any single item of the result
and displaying the available service in a short form. Included are standard
templates, which make use of the in-HTML logic features of AngularJS such as
`ng-if` and `ng-repeat`. The output using these templates may look like this:

![example output of ng-daia with standard templates](ngdaia_demo_EN_full.png)

In this example you can see the nested structure of the DAIA data model, which
consists of an outer layer for institutional and document information as a
whole. The document object contains one or more items, which can be further
attributed to departments of the holding institution or a location (e.g. shelf
mark). Within each item object, the availability for specific services is
enclosed, as well as limitations and further options for those services (such
as reserving a currently lent physical copy). The filter `daia-simple` would in
this example return an object with a field `status: 'loan'`, as loan is
currently the most preferable available service. In addition, the templates
provide localization capabilities using
[angular-translate](http://angular-translate.github.io/).

Utilizing this tool will allow website creators to easily embedd either current
information concerning a specific document, or providing a way to request
availability information from multiple sources.

# Conclusions

AngularJS modules, such as ng-suggest and ng-daia presented above, provide an
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

As is the philosophy of AngularJS easily implementable and reusable solution to this problem. It retrieves the suggestions of a specified service and, using the [Bootstrap UI](http://angular-ui.github.io/bootstrap/), provides a typeahead function for web applications.

How can the vicious circle of missing APIs to library services be broken?

(this article is based on
the assumption that libraries actually want to facilitate the use of their
servics. In some cases this assumption might be wrong).

an easy way how library services, if available in form of APIs, 
can be exposed, used and integrated into other web applications.

---

# References
