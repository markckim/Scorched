//
//  BMContactListener.m
//  Scorched
//
//  Created by Mark Kim on 11/25/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "BMContactListener.h"

BMContactListener::BMContactListener() : _contacts() {}

BMContactListener::~BMContactListener() {}

void BMContactListener::BeginContact(b2Contact *contact)
{
    BMContact bmContact = BMContact(contact->GetFixtureA(), contact->GetFixtureB());
    _contacts.push_back(bmContact);
}

void BMContactListener::EndContact(b2Contact *contact)
{
    BMContact bmContact = BMContact(contact->GetFixtureA(), contact->GetFixtureB());
    std::vector<BMContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), bmContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void BMContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {}

void BMContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse)
{    
    BMContact bmContactToFind = BMContact(contact->GetFixtureA(), contact->GetFixtureB());
    std::vector<BMContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), bmContactToFind);
    if (pos != _contacts.end()) {
        pos->force = impulse->normalImpulses[0];
    }
}








