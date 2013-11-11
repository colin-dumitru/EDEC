
## Authorization ##

Retrieves information regarding the currently logged in user, such as name and avatar.

**Request**:  `GET /user.json`

**Response**

    {
        'name': '<User Name>',
        'avatar' : '<base 64 encoded image>',
        'links' : [
            {
                'rel' : 'scan_product|personal_groups|joined_groups',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > GET /user.json
    {
        'name': 'Mark',
        'avatar' : 'iVBORw0KGgoAAA==',
        'links' : [
            {
                'rel' : 'scan_product',
                'method' : 'GET',
                'url' : '/products.json'
            },
            {
                'rel' : 'personal_groups',
                'method' : 'GET',
                'url' : '/groups/created.json'
            },
            {
                'rel' : 'joined_groups',
                'method' : 'GET',
                'url' : '/groups/joined.json'
            }
        ]
    }
    

## Bar Code Scanning and Products ##

This sections contains information regarding all the knowledge DB available to the end user, including products, ingredients, companies and methods of finding this information.

### Product ###

**Request**:  `GET /products/:barCodeId.json`

Retrieves information for a particular product which has the given bar-code id. If the product is not found, the the HTTP status code is set to 404.

**Response**

    {
        'name': '<product name>',
        'image' : '<base 64 encoded image>',
        'ingredients' : [
            {
                'id' : <ingredient id>,
                'links' : [
                    'rel' : 'ingredient_info',
                    'method' : 'GET|POST|CREATE|DELETE',
                    'url' : '<action url>'
                ]
            }
            ...
        ],
        'company' : {
            'id' : <company id>,
            'links': [
                {
                    'rel' : 'company_info',
                    'method' : 'GET',
                    'url' : '<action url>'
                }
            ]
        }
    }

**Example**

    > GET /products/5942105002167.json
    {
        'name': 'Karo corn syrup',
        'image' : 'iVBORw0KGgoAAA==',
        'ingredients' : [
            {
                'id' : 2487,
                'links' : [
                    'rel' : 'ingredient_info',
                    'method' : 'GET',
                    'url' : '/ingredients/2487.json'
                ]
            }
        ],
        'company' : {
            'id' : 547,
            'links': [
                {
                    'rel' : 'company_info',
                    'method' : 'GET',
                    'url' : '/companies/547.json'
                }
            ]
        }
    }
    
### Product Verdict ###

**Request**:  `GET /products/:barCodeId/verdict.json`

Gives the verdict on a product, if the the user should buy it or not. If the `status` field is set to `red` then the `reasons` field is set to an array containing a list of reasons with why the product was filtered.

**Response**

    {
        'status' : 'green|red',
        'reasons' : [
            '<reason why it was filtered>`,
            ...
        ]
    }

**Example**

    > GET /products/5942105002167/verdict.json
    {
        'status' : 'red',
        'reasons' : [
            'Ingredient "Corn" is made by company "Monsato"`
        ]
    }

### Product Search ###

Retrieves all products which match the given search term.

**Request**:  `GET /products/search/:name.json`

**Response**

    [
        {
            'id' : <product barcode id>,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
    ]

**Example**

    > GET /products/search/syrup.json
    [
        {
            'id' : 5942105002167,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5942105002167.json'
            ]
        }
    ]

### Create Product ###

Creates a new product with the given information.

**Request**:  `CREATE /products.json`

    {
        'id' : <barcode id>,
        'name': '<product name>',
        'image' : '<base 64 encoded image>',
        'ingredients' : [
            <ingredient id>,
            ...
        ],
        'company' : <company id>
    }

**Response**

     {
        'id' : <barcode id>,
        'links' : [
            'rel' : 'product_info',
            'method' : 'GET|POST|CREATE|DELETE',
            'url' : '<action url>'
        ]
    }

**Example**

    > CREATE /products.json
    {
        'id' : 5942105002167,
        'name': 'Karo corn syrup',
        'image' : 'iVBORw0KGgoAAA==',
        'ingredients' : [
            2487
        ],
        'company' : 547
    }
    <
    {
        'id' : 5942105002167,
        'links' : [
            'rel' : 'product_info',
            'method' : 'GET',
            'url' : '/products/5942105002167.json'
        ]
    }
    

### Similar Products ###

Retrieves all similar products with the product given by the bar code id.

**Request**:  `GET /products/:barCodeId/similar.json`

**Response**

    [
        {
            'id' : <bar code id>,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        ...
    ]

**Example**

    > GET /products/5942105002167/similar.json
    [
        {
            'id' : 5871354192744,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5871354192744.json'
            ]
    ]

### Ingredient ###

**Request**:  `GET /ingredients/:id.json`

Retrieves information about the ingredient with the given id.

**Response**

    {
        'name': '<ingredient name>',
        'company' : <company id>
    }

**Example**

    > GET /ingredients/2487.json
    {
        'name': 'Monsanto corn',
        'company' : 312
    }

### Ingredient Search ###

Retrieves all ingredients which match the given search term.

**Request**:  `GET /ingredients/search/:name.json`

**Response**

    [
        {
            'id' : <ingredient id>,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /ingredients/search/corn.json
    [
        {
            'id' : 2487,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/2487.json'
            ]
        }
    ]

### Company ###

Retrieves information on the company with the given id.

**Request**:  `GET /companies/:id.json`

**Response**

    {
        'name': '<company name>',
        'description' : '<company description>',
        'logo' : '<base 64 encoded image>'
    }

**Example**

    > GET /companies/312.json
    {
        'name': 'Monsanto',
        'description' : 'Monsanto is a sustainable agriculture company.',
        'logo' : 'iVBORw0KGgoAAA=='
    }

### Company Search ###

Retrieves all companies which match the given search term.

**Request**:  `GET /companies/search/:name.json`

**Response**

    [
        {
            <company id>,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /companies/search/Monsanto.json
    [
        {
            312,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/312.json'
            ]
        }
    ]

## Group Management ##

This sections contains actions related to group management and discovery.

### Created Group Listings ###

Lists all groups which the user created.

**Request**:  `GET /groups/created.json`

**Response**

    [
        {
            'id' : <group id>,
            'links' : [
                {
                    'rel' : 'group_info|delete_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/created.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051'
                },
                {
                    'rel' : 'delete_group',
                    'method' : 'DELETE',
                    'url' : '/groups/1051'
                }
            ]
        }
    ]

### Joined Group Listings ###

Lists all groups which the user joined.

**Request**:  `GET /groups/joined.json`

**Response**

    [
        {
            'id' : <group id>,
            'links' : [
                {
                    'rel' : 'group_info|leave_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/joined.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'leave_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/leave.json'
                }
            ]
        }
        ...
    ]

### Group Information ###

Retrieves information for the group with the given id.

**Request**:  `GET /groups/:id.json`

**Response**

    {
        'id' : <group id>,
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item' : 'company|product|ingredient',
                'item_id' : <item id>,
                'reason' : '<reason filtered>'
            }
            ...
        ],
        'links' : [
            {
                'rel' : 'join_group|leave_group',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ],
        'has_users' : true|false
    }

**Example**

    > GET /groups/1051.json
    {
        'id' : 1051,
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensuring environmental safety.',
        'rules' : [
        `   {
                'item' : 'company',
                'item_id' : 312,
                'reason' : 'Uses unsafe pesticides'
            },
        `   {
                'item' : 'ingredient',
                'item_id' : 2487,
                'reason' : 'Made by Monsanto'
            }
        ],
        'links' : [
            {
                'rel' : 'join_group',
                'method' : 'GET',
                'url' : '/groups/1051/join.json'
            },
            {
                'rel' : 'leave_group',
                'method' : 'POST',
                'url' : '/groups/1051/leave.json'
            }
        ],
        'has_users' : true
    }

### Group Search ###

Retrieves all groups which match the given search term.

**Request**:  `GET /groups/search/:name.json`

**Response**

    [
        {
            'id' : <group id>,
            'links' : [
                {
                    'rel' : 'group_info|join_group|leave_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/search/Monsanto.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'join_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/join.json'
                },
                {
                    'rel' : 'leave_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/leave.json'
                }
            ]
        }
    ]

### Group Suggestions - Personal ###

Suggests groups based on the groups the user has already joined.

**Request**:  `GET /groups/suggest/personal.json`

**Response**

    [
        {
            'id' : <group id>,
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/suggest/personal.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'join_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/join.json'
                }
            ]
        }
    ]

### Group Suggestions - Friends ###

Suggests groups based on the groups the user's friends have joined.

**Request**:  `GET /groups/suggest/friends.json`

**Response**

    [
        {
            'id' : <group id>,
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/suggest/friends.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'join_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/join.json'
                }
            ]
        }
    ]

### Trending Group ###

Retrieves the groups which are trending in the current and past week.

**Request**:  `GET /groups/trending.json`

**Response**

    [
        {
            'id' : '<group id>',
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|CREATE',
                    'url' : '<action url>'
                }
                ...
            ]
        }
        ...
    ]

**Example**

    > GET /groups/trending.json
    [
        {
            'id' : 1051,
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'join_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/join.json'
                }
            ]
        }
    ]

### Join Group ###

Joins the group with the given id.

**Request**:  `GET /groups/:id/join.json`

**Response**

    {
        'id' : <group id>,
        'links' : [
            {
                'rel' : 'group_info|leave_group',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > GET /groups/1051/join.json
    {
        'id' : 1051,
        'links' : [
            {
                'rel' : 'group_info',
                'method' : 'GET',
                'url' : '/groups/1051.json'
            },
            {
                'rel' : 'leave_group',
                'method' : 'POST',
                'url' : '/groups/1051/leave.json'
            }
        ]
    }

### Leave Group ###

Leaves the group with the given id.

**Request**:  `GET /groups/:id/leave.json`

**Response**

    {
        'id' : <group id>,
        'links' : [
            {
                'rel' : 'group_info|join_group',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > GET /groups/1051/leave.json
    {
        'id' : 1051,
        'links' : [
            {
                'rel' : 'group_info',
                'method' : 'GET',
                'url' : '/groups/1051.json'
            },
            {
                'rel' : 'join_group',
                'method' : 'POST',
                'url' : '/groups/1051.json'
            }
        ]
    }

### Create Group ###

Creates a new group using the information sent to the server.

**Request**:  `CREATE /groups.json`

    {
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item' : 'company|product|ingredient',
                'reason' : '<why the item is filtered>'
            }
            ...
        ]
    }

**Response**

    {
        'id' : '<group id>',
        'links' : [
            {
                'rel' : 'group_info|delete_group',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > CREATE /groups.json
    {
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensuring environmental safety.',
        'rules' : [
        `   {
                'item' : 'company',
                'item_id' : 312,
                'reason' : 'Uses unsafe pesticides'
            },
        `   {
                'item' : 'ingredient',
                'item_id' : 2487,
                'reason' : 'Made by Monsanto'
            }
        ]
    }
    >
    {
        'id' : 1051,
        'links' : [
            {
                'rel' : 'group_info',
                'method' : 'GET',
                'url' : '/groups/1051.json'
            },
            {
                'rel' : 'delete_group',
                'method' : 'DELETE',
                'url' : '/groups/1051.json'
            }
        ]
    }

### Delete Group ###

Deletes the group owned by the user and with the given id. If the HTTP status code is anything other than 200, then the returned `message` field contains the reason why the deletion failed.

**Request**:  `DELETE /groups/:id.json`

**Response**

    {
        'message' : '<fail message>'
    }

**Example**

    > `DELETE /groups/1051.json`

### Update Group ###

Updates the group with the information sent to the server.

**Request**:  `POST /groups/:id.json`

    {
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item' : 'company|product|ingredient',
                'reason' : '<why the item is filtered>'
            }
            ...
        ]
    }

**Response**

    {
        'id' : '<group id>',
        'links' : [
            {
                'rel' : 'group_info|delete_group',
                'method' : 'GET|POST|DELETE|CREATE',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > POST /groups/1051.json
    {
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensure environmental safety.',
        'rules' : [
        `   {
                'item' : 'company',
                'item_id' : 312,
                'reason' : 'Uses unsafe pesticides'
            },
        `   {
                'item' : 'ingredient',
                'item_id' : 2487,
                'reason' : 'Made by Monsanto'
            }
        ]
    }
    <
    {
        'id' : 1051,
        'links' : [
            {
                'rel' : 'group_info',
                'method' : 'GET',
                'url' : '/groups/1051.json'
            },
            {
                'rel' : 'delete_group',
                'method' : 'DELETE',
                'url' : '/groups/1051.json'
            }
        ]
    }


## Statistics ##

This section contains information for actions which retrieve various statistics regarding the resources managed by the server, including the most blacklisted companies, ingredients and products.

### Top 3 Ingredients ###

Retrieves the top 3 most blacklisted ingredients.

**Request**:  `GET /stats/top/ingredients.json`

**Response**

    [
        {
            'id' : <ingredient id>,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/ingredients.json
    [
        {
            'id' : 2487,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/2487'
            ]
        },
        {
            'id' : 5236,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/5236'
            ]
        },
        {
            'id' : 1102,
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/1102'
            ]
        }
    ]

### Top 3 Products ###

Retrieves the top 3 most blacklisted products.

**Request**:  `GET /stats/top/products.json`

**Response**

    [
        {
            'id' : <product id>,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/products.json
    [
        {
            'id' : 5942105002167,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5942105002167'
            ]
        },
        {
            'id' : 5835741514871,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5835741514871'
            ]
        },
        {
            'id' : 4112973551864,
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/4112973551864'
            ]
        }
    ]

### Top 3 Companies ###

Retrieves the top 3 most blacklisted companies.

**Request**:  `GET /stats/top/companies.json`

**Response**

    [
        {
            'id' : <company id>,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET|POST|CREATE|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/companies.json
    [
        {
            'id' : 312,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/312'
            ]
        },
        {
            'id' : 101,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/101'
            ]
        },
        {
            'id' : 4805,
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/4805'
            ]
        }
    ]


> Written with [StackEdit](https://stackedit.io/).