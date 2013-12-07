
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
                'method' : 'GET|POST|DELETE|PUT',
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
                'id' : '<ingredient uri>',
                'links' : [
                    'rel' : 'ingredient_info',
                    'method' : 'GET|POST|PUT|DELETE',
                    'url' : '<action url>'
                ]
            }
            ...
        ],
        'company' : {
            'id' : '<company uri>',
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
                'id' : '/ingredients/2487',
                'links' : [
                    'rel' : 'ingredient_info',
                    'method' : 'GET',
                    'url' : '/ingredients/2487.json'
                ]
            }
        ],
        'company' : {
            'id' : '/companies/547',
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
            '<filter reason uri>`,
            ...
        ]
    }

**Example**

    > GET /products/5942105002167/verdict.json
    {
        'status' : 'red',
        'reasons' : [
            '/filter_reasons/1`
        ]
    }

### Product Search ###

Retrieves all products which match the given search term.

**Request**:  `GET /products/:name/name.json`

**Response**

    [
        {
            'id' : '<product uri>',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
    ]

**Example**

    > GET /products/syrup/name.json
    [
        {
            'id' : '/products/5942105002167',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5942105002167.json'
            ]
        }
    ]

### Create Product ###

Creates a new product with the given information.

**Request**:  `POST /products.json`

    {
        'id' : '<barcode id>',
        'name': '<product name>',
        'image' : '<base 64 encoded image>',
        'ingredients' : [
            '<ingredient uri>',
            ...
        ],
        'company' : <company id>
    }

**Response**

     {
        'id' : '<barcode uri>',
        'links' : [
            'rel' : 'product_info',
            'method' : 'GET|POST|PUT|DELETE',
            'url' : '<action url>'
        ]
    }

**Example**

    > POST /products.json
    {
        'id' : 5942105002167,
        'name': 'Karo corn syrup',
        'image' : 'iVBORw0KGgoAAA==',
        'ingredients' : [
            '/ingredients/2487'
        ],
        'company' : '/companies/547'
    }
    <
    {
        'id' : '/products/5942105002167',
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
            'id' : '<product uri>',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        ...
    ]

**Example**

    > GET /products/5942105002167/similar.json
    [
        {
            'id' : '/products/5871354192744',
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
        'company' : '<company uri>'
    }

**Example**

    > GET /ingredients/2487.json
    {
        'name': 'Monsanto corn',
        'company' : '/companies/312'
    }

### Ingredient Search ###

Retrieves all ingredients which match the given search term.

**Request**:  `GET /ingredients/:name/search.json`

**Response**

    [
        {
            'id' : '<ingredient uri>',
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /ingredients/corn/search.json
    [
        {
            'id' : '/ingredients/2487',
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

**Request**:  `GET /companies/:name/search.json`

**Response**

    [
        {
            'id' : '<company uri>',
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /companies/search/Monsanto.json
    [
        {
            'id' : '/companies/312',
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
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|N',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
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
    ]

### Joined Group Listings ###

Lists all groups which the user joined.

**Request**:  `GET /groups/joined.json`

**Response**

    [
        {
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|leave_group',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
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
        'id' : '<group uri>',
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item_id' : '<item uri>',
                'filter_reason_id' : '<filter reason uri>'
            }
            ...
        ],
        'links' : [
            {
                'rel' : 'join_group|leave_group',
                'method' : 'GET|POST|DELETE|PUT',
                'url' : '<action url>'
            }
            ...
        ],
        'has_users' : true|false
    }

**Example**

    > GET /groups/1051.json
    {
        'id' : '/groups/1051',
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensuring environmental safety.',
        'rules' : [
        `   {
                'item_id' : '/companies/312',
                'filter_reason_id' : '/filter_reasons/651'
            },
        `   {
                'item_id' : '/ingredients/2487',
                'filter_reason_id' : '/filter_reasons/77897'
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
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|join_group|leave_group',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
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
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
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
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
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
            'id' : '<group uri>',
            'links' : [
                {
                    'rel' : 'group_info|join_group',
                    'method' : 'GET|POST|DELETE|PUT',
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
            'id' : '/groups/1051',
            'links' : [
                {
                    'rel' : 'group_info',
                    'method' : 'GET',
                    'url' : '/groups/1051.json'
                },
                {
                    'rel' : 'join_group',
                    'method' : 'POST',
                    'url' : '/groups/1051/join'
                }
            ]
        }
    ]

### Join Group ###

Joins the group with the given id.

**Request**:  `GET /groups/:id/join.json`

**Response**

    {
        'id' : '<group uri>',
        'links' : [
            {
                'rel' : 'group_info|leave_group',
                'method' : 'GET|POST|DELETE|PUT',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > GET /groups/1051/join.json
    {
        'id' : '/groups/1051',
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
        'id' : '<group uri>',
        'links' : [
            {
                'rel' : 'group_info|join_group',
                'method' : 'GET|POST|DELETE|PUT',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > GET /groups/1051/leave.json
    {
        'id' : '/groups/1051',
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

**Request**:  `POST /groups.json`

    {
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item_id' : '<item uri (company, ingredient, product)>',
                'filter_reason_id' : '<filte reason uri>'
            }
            ...
        ]
    }

**Response**

    {
        'id' : '<group uri>',
        'links' : [
            {
                'rel' : 'group_info|delete_group',
                'method' : 'GET|POST|DELETE|PUT',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > POST /groups.json
    {
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensuring environmental safety.',
        'rules' : [
        `   {
                'item_id' : '/companies/312',
                'filter_reason_id' : '/filter_reason_id/651'
            },
        `   {
                'item_id' : '/ingredients/2487',
                'filter_reason_id' : '/filter_reason_id/8488'
            }
        ]
    }
    >
    {
        'id' : '/groups/1051',
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

**Request**:  `PUT /groups/:id.json`

    {
        'title' : '<group title>',
        'logo' : '<base 64 encoded logo>',
        'description' : '<group description>',
        'rules' : [
        `   {
                'item_id' : '<item uri (company, ingredient, product)>',
                'reason' : '<why the item is filtered>'
            }
            ...
        ]
    }

**Response**

    {
        'id' : '<group uri>',
        'links' : [
            {
                'rel' : 'group_info|delete_group',
                'method' : 'GET|POST|DELETE|PUT',
                'url' : '<action url>'
            }
            ...
        ]
    }

**Example**

    > PUT /groups/1051.json
    {
        'title' : 'Anti Monsanto Group',
        'logo' : 'iVBORw0KGgoAAA==',
        'description' : 'A group dedicated to ensure environmental safety.',
        'rules' : [
        `   {
                'item_id' : '/companies/312',
                'reason' : 'Uses unsafe pesticides'
            },
        `   {
                'item_id' : '/ingredients/2487',
                'reason' : 'Made by Monsanto'
            }
        ]
    }
    <
    {
        'id' : '/companies/1051',
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
    
### Filter Reasons ###

Retrieves a list of available filter reasons. For performance reasons, the filter description is also included inside the response.

**Request**:  `GET /filter_reasons.json`

**Response**

    {
        [
            'id' : '<reason uri>',
            'for_resource' : '<resource type (company, ingredient, product)>',
            'short_description' : '<reason description>',
            'links' : [
                {
                    'rel' : 'reason_info',
                    'method' : 'GET',
                    'url' : '<action url>'
                }
            ]
        ]
        ...
    }

**Example**

    > GET /filter_reasons.json
    {
        [
            'id' : '/filter_reasons/6874',
            'for_resource' : '/companies',
            'short_description' : 'Animal Abuse',
            'links' : [
                {
                    'rel' : 'reason_info',
                    'method' : 'GET',
                    'url' : '/filter_reasons/6874.json'
                }
            ]
        ],
        [
            'id' : '/filter_reasons/787',
            'for_resource' : '/ingredients',
            'short_description' : 'Can cause cancer',
            'links' : [
                {
                    'rel' : 'reason_info',
                    'method' : 'GET',
                    'url' : '/filter_reasons/787.json'
                }
            ]
        ],
        [
            'id' : '/filter_reasons/9888',
            'for_resource' : '/products',
            'short_description' : 'Unsafe work prctices',
            'links' : [
                {
                    'rel' : 'reason_info',
                    'method' : 'GET',
                    'url' : '/filter_reasons/9888.json'
                }
            ]
        ]
    }
    
### Filter Reason Information ###

Retrieves information for a single filter reason

**Request**:  `GET /filter_reasons/:id.json`

**Response**

    {
        'id' : '<reason uri>',
        'for_resource' : '<resource type (company, ingredient, product)>',
        'short_description' : '<reason description>'
    }

**Example**

    > GET /filter_reasons/6874.json
    {
        'id' : '/filter_reasons/6874',
        'for_resource' : '/companies',
        'short_description' : 'Animal Abuse'
    }


## Statistics ##

This section contains information for actions which retrieve various statistics regarding the resources managed by the server, including the most blacklisted companies, ingredients and products.

### Top 3 Ingredients ###

Retrieves the top 3 most blacklisted ingredients.

**Request**:  `GET /stats/top/ingredients.json`

**Response**

    [
        {
            'id' : '<ingredient uri>',
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/ingredients.json
    [
        {
            'id' : '/ingredients/2487',
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/2487'
            ]
        },
        {
            'id' : '/ingredients/5236',
            'links' : [
                'rel' : 'ingredient_info',
                'method' : 'GET',
                'url' : '/ingredients/5236'
            ]
        },
        {
            'id' : '/ingredients/1102',
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
            'id' : '<product uri>',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/products.json
    [
        {
            'id' : '/products/5942105002167',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5942105002167'
            ]
        },
        {
            'id' : '/products/5835741514871',
            'links' : [
                'rel' : 'product_info',
                'method' : 'GET',
                'url' : '/products/5835741514871'
            ]
        },
        {
            'id' : '/products/4112973551864',
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
            'id' : '<company uri>',
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET|POST|PUT|DELETE',
                'url' : '<action url>'
            ]
        }
        ...
    ]

**Example**

    > GET /stats/top/companies.json
    [
        {
            'id' : '/companies/312',
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/312'
            ]
        },
        {
            'id' : '/companies/101',
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/101'
            ]
        },
        {
            'id' : '/companies/4805',
            'links' : [
                'rel' : 'company_info',
                'method' : 'GET',
                'url' : '/companies/4805'
            ]
        }
    ]


> Written with [StackEdit](https://stackedit.io/).