Config = {}

Config.Usage = {
    Range = 15.0,
    DrawDistance = 25.0
}

Config.Placing = {
    Duration = 10000,
    Animation = {
        dict = 'anim@spray_spraycan',
        name = 'spraying',
        flag = 49
    },
    Prop = 'prop_spray_can_01',
    Materials = {
        spray_can = 1,
        required_amount = 1
    }
}

Config.GraffitiTypes = {
    {
        name = 'tag1',
        label = 'Basic Tag',
        image = 'images/tag1.png',
        material = 'spray_can'
    },
    {
        name = 'tag2', 
        label = 'Gang Sign',
        image = 'images/tag2.png',
        material = 'spray_can'
    },
    {
        name = 'tag3',
        label = 'Art Piece',
        image = 'images/tag3.png',
        material = 'spray_can'
    }
}

Config.Database = {
    Table = 'graffiti_tags',
    Columns = {
        id = 'id',
        x = 'x',
        y = 'y',
        z = 'z',
        heading = 'heading',
        url = 'image_url',
        creator = 'creator',
        created_at = 'created_at'
    }
}

Config.Removal = {
    Duration = 8000,
    Animation = {
        dict = 'anim@cleaning',
        name = 'clean_spray',
        flag = 49
    },
    Prop = 'prop_cleaning_sol',
    Material = 'graffiti_remover',
    RequiredAmount = 1
}