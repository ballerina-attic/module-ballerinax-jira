package tests;

struct Person {
    string name;
    int age;
    string street;
    string city;
}

struct User {
    string username;
    string location;
    int age;
}

function getFirstName (string name)  returns string {
    string[] names = name.split(" ");
    return names[0];
}

transformer <Person p, User u> {
    u.username = getFirstName(p.name.toUpperCase());
    u.location = p.street + ", " + p.city;
    u.age = p.age;
}

function personToUser(Person p) returns User {
    User u = {};
    u.username = getFirstName(p.name.toUpperCase());
    u.location = p.street + ", " + p.city;
    u.age = p.age;
    return u;
}

function <Person p> toUser() returns User{
    User u = {};
    u.username = getFirstName(p.name.toUpperCase());
    u.location = p.street + ", " + p.city;
    u.age = p.age;
    return u;
}

function main (string[] args) {
    Person person = {name:"John Allen", age:30, street: "York St", city:"London"};
    User user = {};
    //using transformer
    user = <User> person;
    //using function
    user = personToUser(person);
    //using struct-bound function
    user = person.toUser();
}