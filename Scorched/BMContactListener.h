//
//  BMContactListener.h
//  Scorched
//
//  Created by Mark Kim on 11/25/12.
//  Copyright (c) 2012 Mark Kim. All rights reserved.
//

#import "Box2D.h"
#import <algorithm>
#import <vector>

struct BMContact
{
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    float32 force;
    bool operator==(const BMContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
    
    BMContact(b2Fixture *a, b2Fixture *b) : fixtureA(a), fixtureB(b), force(0.0) {}
};

class BMContactListener : public b2ContactListener
{
public:
    std::vector<BMContact> _contacts;
    
    BMContactListener();
    ~BMContactListener();
    
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};