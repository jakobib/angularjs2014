% Exposing library services with AngularJS
% Jakob Voß; Moritz Horn
% 2014

This article gives an introduction to AngularJS in general and two AngularJS
modules for accessing library services in particular.

**THIS IS A DRAFT, CURRENTLY BEING EDITED**

# Introduction

*...motivation to expose library services with AngularJS...*

The demand to open up library systems through web services has been known for 
years [@Breeding2009]. Nevertheless service oriented architecture (SOA), 
that is to divide an application into loosely coupled modules that can
be used independently, is still not common in library software.

...

The following diagram illustrates the general architecture:

![getting a library service into a web application](layers.png)

# AngularJS

As one of several JavaScript frameworks, [AngularJS](https://angularjs.org/) aims to enhance the functionality of the language by providing features supporting implementation and testing. The first tool for facilitating usability is the promotion of discrete submodules, in which different behaviors can be defined seperately of each other. These "directives" can then be easily reused on their own in different applications. They are also a tool for seperating server side logic from client views, accomplished by an intricate template solution. AngularJS supports the inclusion of html-code via those templates, which can be assigned unique scopes, again to promote the reduction of dependencies. Combined with this functionality, the framework provides built-in two-way data binding. This in turn adds a lot of options for HTML coding, like the possibility to display variable values, automatically updated during runtime (Angular provides its curly bracket `{{}}` syntax to this end). Furthermore, AngularJS provides modules for including basic programming syntax into HTML, like if-prompts or loops (`ng-if` and `ng-repeat`, respectively), which can simply be used as parameters. For example,

```
<ul ng-repeat="d in data">
    <li ng-if="d.id">{{d.value}}</li>
</ul>
```

will display every index-item `value` of the `data` scope, if the subfield `data.id` exists for the specific item. Combined with the option to reuse other prebuilt modules, this greatly enriches the possibilities of DOM-manipulation.



*general overview of AngularJS (how it works, strength, alternatives...)*

* declarative HTML (custom HTML tags and attributes) as "directives"
* expressions and templates
* separation of logic/view layer
* separated scopes and two-way data-binding

* AngularJS is designed to facilitate unit testing. Functionality of
  applications is broken into parts that can be tested and reused
  independently.

* modules, some of them listed at <http://ngmodules.org/>

...aka widgets...to build applications...

# Examples

The practical inclusion of library services in websites with AngularJS will be illustrated with two examples. Both have been implemented as AngularJS modules for easy reuse. First, ng-suggest provides access to OpenSearch Suggestions and SeeAlso API and second, ng-daia provides access to availability information with DAIA.

## Embedding Suggestions with ng-suggest

The OpenSearch standard for search engine description includes a specification for how to query search suggestions and autocomplete, as provided by many search applications. The method can also be used to support tagging with controlled vocabularies (Nagaya et al. 2011) or by recommendation services to dynamically display additional information (Voß 2008). A search suggestion, as specified by OpenSearch Suggestions (Clinton 2006) consists of a JSON array:

    [
      ...
    ]

Despite the simplicity of this format, making use of it still requires a client library.

![](http://ariadne-media.ukoln.info/grfx/img/issue57-voss/figure-1.jpg)

*...TODO: add another screenshot of search suggestions...*

As is the philosophy of AngularJS, the [ng-suggest module](http://gbv.github.io/ng-suggest/) is aimed at providing an easily implementable and reusable solution to this problem. It retrieves the suggestions of a specified service and, using the [Bootstrap UI](http://angular-ui.github.io/bootstrap/), provides a typeahead function for web applications.


Similar services use other JSON formats, so ng-suggest supports mapping from these to OpenSerach suggestions.

## Embedding Availability Information with ng-daia

The [Document Availability Information API (DAIA)](http://www.gbv.de/wikis/cls/DAIA_-_Document_Availability_Information_API) defines a data model and an HTTP API for accessing information about the current availability of documents. Its aim is to provide a way for libraries to allow open and easy-to-use access to holding information from their catalogs. This, in turn, enables the inclusion of document availability information in external applications and websites. Among other formats, DAIA provides availability information in JSON, the first choice for web applications written in JavaScript. The AngularJS module ng-daia implements client code to execute and process a DAIA query and to display holding information in convenient form. The integration into HTML is exemplarily documented in the following code: 

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

ng-daia is hosted in a public git repository, documented and downloadable at <http://gbv.github.io/ng-daia/>. The module utilizes its directives to query a DAIA server and transform the received object to control the displaying of specific parts of information. To achieve a compact structure, there are different directives for the response as a whole, a single item of the result and the information concerning its current availability. The availability of documents in DAIA is split into several independent services (openaccess, loan, interloan and presentation), which can be reflected in the implementation. Furthermore, `daia-simple` defines an additional format provided by this module, providing the most preferable status for any single item of the result and displaying the available service in a short form. Included are standard templates, which make use of the in-HTML logic features of AngularJS such as `ng-if` and `ng-repeat`. The output using these templates may look like this:

 ![example output of ng-daia with standard templates](ngdaia_demo_EN_full.png)

In this example you can see the nested structure of the DAIA data model, which consists of an outer layer for institutional and document information as a whole. The document object contains one or more items, which can be further attributed to departments of the holding institution or a location (e.g. shelf mark). Within each item object, the availability for specific services is enclosed, as well as limitations and further options for those services (such as reserving a currently lent physical copy). The filter `daia-simple` would in this example return an object with a field `status: 'loan'`, as loan is currently the most preferable available service. In addition, the templates provide localization capabilities using [angular-translate](http://angular-translate.github.io/).

Utilizing this tool will allow website creators to easily embedd either current information concerning a specific document, or providing a way to request availability information from multiple sources.

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
principle illustrated in the initial diagram above makes sense. Libraryies
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

# References

* Marshall Breeding: Opening up Library Systems through Web Services and SOA: Hype or Reality?. 2009
* AngularJS Modules. <http://ngmodules.org/>
* Shun Nagaya, Yutaka Hayashi, Shuhei Otani and Keizo Itabashi: *Controlled Terms or Free Terms? A JavaScript Library to Utilize Subject Headings and Thesauri on the Web*. code4lib journal Issue 15, 2011-10-31 <http://journal.code4lib.org/articles/5994>
* Document Availability Information API (DAIA)
* DeWitt Clinton: *OpenSearch Suggestions*.
  <http://www.opensearch.org/Specifications/OpenSearch/Extensions/Suggestions>. 2006
* Jakob Voß: *SeeAlso: A Simple Linkserver Protocol*. Ariadne Issue 57, 2008
  <http://www.ariadne.ac.uk/issue57/voss/>
* ...

