Seshook Specs
===

Ce document est une courte documentation technique

## Simple Roadmap

### version 1

- Authentification
- Recherche et création de spots
- Upload d'images
- Édition du profile utilisateur
- Une application mobile: Android ou iOS

### version 2

- Commentaires, Évènements, Followers
- Deux application mobile
- Client web

## User Stories

- User can login
- User can register
- User can connect through facebook
- User can recover his password through reset email
- User can edit his own profile
- User can view other users public informations
- User can search for spots around him
- User can search for spots by address, city, state, region, country, name
- User can search spots by categories, popularity, practicability, sports
- User can view spot description from map or list
- User can find related spot on spot details page
- User can like or dislike a spot
- User can submit a spot
- User can view submitted pending spot and vote for approval
- User can create an album
- User can add pictures to his albums or the default public album
- User can create events and edit them
- User can attend an event
- User can can link album to a spot or an event
- User can add comment on pictures, albums, spots and events
- User gets notification for spots created in his city, region or country
- User gets spots suggestion ?
- User has a custom news feed ?

## TODO

- ~~Background jobs  `HOT !!!`~~
- ~~Admin image management~~
- ~~Ember authentication~~ (still needs register)
- ~~Import sample images~~
- [API] secure routes
- [API] dev & test routes (controllers, serialization)
- [ADMIN] fix carrierwave fallback image
- [EMBER] register
- [EMBER] map component w/ tests
- [EMBER] side list
- [EMBER] dynamic search
- [CORE] Elastic search index
- [CORE] Search service ?

##### BRIGHT FUTURE MOTHERFUCKER

![Alt text](http://www.quickmeme.com/img/ed/ed3d0cc3b30900cb51389d1d6a94597ef3c769cddccc1ad27649a26e7f8a89bb.jpg)

## Database tables and fields

#### User

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| email        | string  | not null         |
| password     | string  | not null         |

#### Spot

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| name         | string  | not null         |

#### Address

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| street       | string  | not null         |
| city         | string  | not null         |
| zip          | string  | none             |
| state        | string  | none             |
| country_code | string  | size 2, not null |

#### Album

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| user_id      | integer | not null         |
| name         | string  | not null         |

#### Image

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| user_id      | integer | not null         |
| album_id     | integer | not null         |
| size         | integer | none             |
| content_type | string  | none             |
| file         | string  | not null         |

#### Comment

| column         | type    | constrain      |
|----------------|---------|----------------|
| id             | integer | not null       |
| user_id        | integer | not null       |
| comment_id     | integer | none           |
| commentable_id | integer | not null       |
| content        | string  | not null       |

#### Categorie

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| user_id      | integer | not null         |
| name         | string  | not null         |


#### SpotCategorie

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| categorie_id | integer | not null         |
| spot_id      | integer | not null         |

#### Categorie

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| user_id      | integer | not null         |
| name         | string  | not null         |

#### EventType

| column       | type    | constrain        |
|--------------|---------|------------------|
| id           | integer | not null         |
| type         | string  | not null         |

#### Event

| column        | type    | constrain       |
|---------------|---------|-----------------|
| id            | integer | not null        |
| event_type_id | integer | none            |
| name          | string  | not null        |
| description   | string  | not null        |
| start_at      | string  | not null        |
| end_at        | string  | not null        |

#### Attendee

| column        | type    | constrain        |
|---------------|---------|------------------|
| id            | integer | not null         |
| user_id       | integer | not null         |
| event_id      | integer | not null         |

#### Following

| column        | type    | constrain        |
|---------------|---------|------------------|
| id            | integer | not null         |
| follower_id   | integer | not null         |
| following_id  | integer | not null         |
