% Exposing library services with AngularJS

This article gives an introduction into AngularJS in general and two AngularJS
modules to access library services in particular.

# Introduction

*motivation to expose library services with AngularJS...*

* Requires first to provide core library services via APIs
* Service Oriented Architecture, that is to divide an application
  into loosely coupled modules that can be used independently,
  is rarely found in library software

![getting a library service into a web application](layers.png)

# AngularJS

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

API use cases:

* OpenSearch Suggestions / SeeAlso
* DAIA

## Embedding Suggestions with ng-suggest

<http://gbv.github.io/ng-suggest/>

...(e.g. Recommender services)...

See also <http://journal.code4lib.org/articles/5994> ...

also used for CSL (?)


## Embedding Availability Information with ng-daia

The Document Availability Information API (DAIA) defines a data model for encoding information about the availability of documents, specified for JSON, XML and RDF. Its aim is to provide a way for libraries to allow open and easy-to-use access to their catalogs. This, in turn, enables the inclusion of document availability information in external applications and websites.

Ng-daia is an AngularJS module for handling DAIA responses in JSON received from a DAIA server. This presents website creators with a way to embed current availability information into their websites or web-apps. It is hosted on a public repository and is documented and downloadable at <http://gbv.github.io/ng-daia/>. The module utilizes its directives to query a DAIA server and transform the received object to control the displaying of specific parts of information. To achieve a compact structure, there are different directives for the response as a whole, a single item of the result and the information concerning its current availability. The availability of domuments in DAIA is split into several independent services (openaccess, loan, interloan and presentation), which can be reflected in the implementation. Furthermore, daia-simple defines an additional format provided by this module, providing the most preferable result for any single item of the result and displaying the available service in a short form. Included are standard templates, which make use of the in-HTML logic features of AngularJS such as ng-if and ng-repeat. In addition, the templates provide localization capabilities using [angular-translate](http://angular-translate.github.io/).


...


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
principle illustrated in the initial figure above makes sense. Libraryies
should not only expose their services via openly specified APIs but also
provide client libraries to facilitate the integration of these services into
web applications. To minimize the work of doing so, one should build on
standardized APIs instead of (re)inventing new APIs for every library system.

...lessons learned: development of an API and an API client as AngularJS module
is fruitful

Candidates for most missing AngularJS modules to access library services: SRU
and/or OpenSearch (see http://dlib.org/dlib/july10/hammond/07hammond.html for a
description/example of both).

...If no common API exists, one must specify one...  for instance at GBV we are
evaluating APIs to access controlled vocabularies expressed in SKOS (ng-skos)...

...some final words...

# References

* ...
* AngularJS Modules. <http://ngmodules.org/>
* ...
* Jakob Voß: *SeeAlso: A Simple Linkserver Protocol*. Ariadne Issue 57, 2008
  <http://www.ariadne.ac.uk/issue57/voss/>
* ...

