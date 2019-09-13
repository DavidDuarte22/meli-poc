//
//  Product.swift
//  Meli-Poc
//
//  Created by David Duarte on 07/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct Product: Codable {
    var id: String
    var title: String
    var price: String
    var currency_id: String
    
}

/* Mock Object
 
 
{
    "id": "MLA786117240",
    "site_id": "MLA",
    "title": "iPod Touch 5ta Generación 32 Gigas",
    "seller": {
        "id": 178460733,
        "power_seller_status": null,
        "car_dealer": false,
        "real_estate_agency": false,
        "tags": []
    },
    "price": 3300,
    "currency_id": "ARS",
    "available_quantity": 1,
    "sold_quantity": 0,
    "buying_mode": "buy_it_now",
    "listing_type_id": "gold_special",
    "stop_time": "2039-05-22T20:08:44.000Z",
    "condition": "used",
    "permalink": "https://articulo.mercadolibre.com.ar/MLA-786117240-ipod-touch-5ta-generacion-32-gigas-_JM",
    "thumbnail": "http://mla-s1-p.mlstatic.com/743054-MLA28371111319_102018-I.jpg",
    "accepts_mercadopago": true,
    "installments": {
        "quantity": 12,
        "amount": 450.37,
        "rate": 63.77,
        "currency_id": "ARS"
    },
    "address": {
        "state_id": "AR-B",
        "state_name": "Buenos Aires",
        "city_id": null,
        "city_name": "Villa Martelli"
    },
    "shipping": {
        "free_shipping": false,
        "mode": "me2",
        "tags": [],
        "logistic_type": "drop_off",
        "store_pick_up": false
    },
    "seller_address": {
        "id": "",
        "comment": "",
        "address_line": "",
        "zip_code": "",
        "country": {
            "id": "AR",
            "name": "Argentina"
        },
        "state": {
            "id": "AR-B",
            "name": "Buenos Aires"
        },
        "city": {
            "id": null,
            "name": "Villa Martelli"
        },
        "latitude": "",
        "longitude": ""
    },
    "attributes": [
    {
    "attribute_group_id": "OTHERS",
    "attribute_group_name": "Otros",
    "source": 1,
    "id": "BRAND",
    "name": "Marca",
    "value_id": "9344",
    "value_name": "Apple",
    "value_struct": null
    },
    {
    "value_name": "Usado",
    "value_struct": null,
    "attribute_group_id": "OTHERS",
    "attribute_group_name": "Otros",
    "source": 1,
    "id": "ITEM_CONDITION",
    "name": "Condición del ítem",
    "value_id": "2230581"
    },
    {
    "attribute_group_name": "Otros",
    "source": 1,
    "id": "LINE",
    "name": "Línea",
    "value_id": null,
    "value_name": "Touch",
    "value_struct": null,
    "attribute_group_id": "OTHERS"
    },
    {
    "value_name": "Ipod Touch",
    "value_struct": null,
    "attribute_group_id": "OTHERS",
    "attribute_group_name": "Otros",
    "source": 1,
    "id": "MODEL",
    "name": "Modelo",
    "value_id": null
    }
    ],
    "original_price": null,
    "category_id": "MLA7262",
    "official_store_id": null,
    "catalog_product_id": null,
    "tags": [
    "poor_quality_picture",
    "immediate_payment",
    "cart_eligible"
    ]
}

 */
