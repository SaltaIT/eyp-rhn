# CHANGELOG

## 0.1.18

* bugfix returncode for rhn::repo when ensure is absent

## 0.1.17

* removed daily checks for repos (we are using repolist)

## 0.1.16

* improved repo detection using regex boundaries

## 0.1.15

* enhanced unless detection for **rhn::repo**

## 0.1.14

* changed **rhn::repo** unless, **yum repolist** instead of **subscription-manager**

## 0.1.12

* enhanced **rhn::repo** checking

## 0.1.11

* **INCOMPATIBLE CHANGE**: renamed **rhn::addrepo** to **rhn::repo**

## 0.1.9

* added **rhn::addrepo**

## 0.1.8

* added **up2date_replace**, default false

## 0.1.6

* subscription manager support
* limited to one daily RHN check
