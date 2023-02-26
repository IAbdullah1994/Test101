/*
* Wayland Additive Ltd Proprietary Information
* ==============================================
*
* Copyright (c) Wayland Additive, 2016.
* ---------------------------------------
*
* All rights reserved.
* No part of this software may be copied or disclosed
* without the prior permission of the copyright holder.
*
* Written by David Knight
* www.knightgraphics.co.uk
* 20021
*/

#include <core/config.h>
#include <core/rc.h>
#include <core/os.h>

#include <pattern/material_autoset.h>
#include <pattern/strategy.h>

static std::map<std::string, std::map<std::string, eb::pattern::strategy_ptr>> strategies;
static std::map<std::string, eb::pattern::material_autoset> autosets;

inline eb::pattern::strategy_ptr create_strategy(const std::string & material, const std::string & name, const eb::pattern::object_type object_type)
{
    eb::pattern::strategy_ptr strategy = std::make_shared<eb::pattern::strategy>(name, object_type, false);
    strategy->set_material(material);
    strategy->set_defaults();

    strategies[material][name] = strategy;

    return strategy;
}

eb::rc generate_strategy()
{

    eb::rc rc;

    const std::string output_path = eb::os::data_dir() + "/data/system/strategy/";
    const std::string binary_ext = ".autoset";
    const std::string json_ext = ".json";

    eb::pattern::strategy_ptr strategy;

    // Vibenite290 --- 2.5mmTile
    strategy = create_strategy("Vibenite290", "2.5mmTile", eb::pattern::object_type::tile);
    strategy->set_value("beam_current", "5.5");
    strategy->set_value("beam_speed", "31200");
    strategy->set_value("contour_count", "1");
    strategy->set_value("hatch_joint", "1");
    strategy->set_value("hatch_margin", "-0.7");
    strategy->set_value("num_meltpools", "32");
    strategy->set_value("point_group", "10");
    strategy->set_value("point_repeat", "69");
    strategy->set_value("tile_overlap", "0.1");
    strategy->set_value("tile_scan", "4");
    strategy->set_value("tile_size", "2.5");
    strategy->set_value("tile_stagger", "1.5");

    // Ti6Al4V --- 5mmTile
    strategy = create_strategy("Ti6Al4V", "5mmTile", eb::pattern::object_type::tile);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "31200");
    strategy->set_value("contour_count", "1");
    strategy->set_value("hatch_joint", "1");
    strategy->set_value("hatch_margin", "-0.7");
    strategy->set_value("num_meltpools", "16");
    strategy->set_value("point_group", "10");
    strategy->set_value("point_repeat", "56");
    strategy->set_value("tile_overlap", "0.1");
    strategy->set_value("tile_scan", "4");
    strategy->set_value("tile_size", "5");
    strategy->set_value("tile_stagger", "3");

    // TestMaterial --- 5mmTile
    strategy = create_strategy("TestMaterial", "5mmTile", eb::pattern::object_type::tile);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "31200");
    strategy->set_value("contour_count", "1");
    strategy->set_value("hatch_joint", "1");
    strategy->set_value("hatch_margin", "-0.7");
    strategy->set_value("num_meltpools", "16");
    strategy->set_value("point_group", "10");
    strategy->set_value("point_repeat", "56");
    strategy->set_value("tile_overlap", "0.1");
    strategy->set_value("tile_scan", "4");
    strategy->set_value("tile_size", "5");
    strategy->set_value("tile_stagger", "3");

    // Ti6Al4V --- OpenSupports
    strategy = create_strategy("Ti6Al4V", "OpenSupports", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "7");
    strategy->set_value("beam_speed", "1100");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_sort", "5");

    // TestMaterial --- OpenSupports
    strategy = create_strategy("TestMaterial", "OpenSupports", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "7");
    strategy->set_value("beam_speed", "1100");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_sort", "5");

    // Ti6Al4V --- InnerContour
    strategy = create_strategy("Ti6Al4V", "InnerContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_offset", "-0.3");
    strategy->set_value("contour_origin", "-0.5");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // Vibenite290 --- InnerContour
    strategy = create_strategy("Vibenite290", "InnerContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_joint", "1");
    strategy->set_value("contour_offset", "-0.3");
    strategy->set_value("contour_origin", "-0.5");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // TestMaterial --- InnerContour
    strategy = create_strategy("TestMaterial", "InnerContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_offset", "-0.3");
    strategy->set_value("contour_origin", "-0.5");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // Ti6Al4V --- OuterContour
    strategy = create_strategy("Ti6Al4V", "OuterContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_offset", "-0.2");
    strategy->set_value("contour_origin", "-0.3");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // Vibenite290 --- OuterContour
    strategy = create_strategy("Vibenite290", "OuterContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_joint", "1");
    strategy->set_value("contour_offset", "-0.2");
    strategy->set_value("contour_origin", "-0.3");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // TestMaterial --- OuterContour
    strategy = create_strategy("TestMaterial", "OuterContour", eb::pattern::object_type::contour);
    strategy->set_value("beam_current", "5");
    strategy->set_value("beam_speed", "15600");
    strategy->set_value("contour_count", "1");
    strategy->set_value("contour_offset", "-0.2");
    strategy->set_value("contour_origin", "-0.3");
    strategy->set_value("num_meltpools", "50");
    strategy->set_value("point_group", "5");
    strategy->set_value("point_repeat", "55");

    // Ti6Al4V --- ClosedSupports
    strategy = create_strategy("Ti6Al4V", "ClosedSupports", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "7");
    strategy->set_value("beam_speed", "1100");

    // TestMaterial --- ClosedSupports
    strategy = create_strategy("TestMaterial", "ClosedSupports", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "7");
    strategy->set_value("beam_speed", "1100");

    // Ti6Al4V --- PlateHeating
    strategy = create_strategy("Ti6Al4V", "PlateHeating", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "50");
    strategy->set_value("beam_speed", "36000");
    strategy->set_value("hatch_margin", "-10");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "100");
    strategy->set_value("num_counts", "5");

    // Vibenite290 --- PlateHeating
    strategy = create_strategy("Vibenite290", "PlateHeating", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "20");
    strategy->set_value("beam_speed", "14000");
    strategy->set_value("hatch_margin", "-10");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "100");
    strategy->set_value("num_counts", "5");

    // TestMaterial --- PlateHeating
    strategy = create_strategy("TestMaterial", "PlateHeating", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "50");
    strategy->set_value("beam_speed", "36000");
    strategy->set_value("hatch_margin", "-10");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "100");
    strategy->set_value("num_counts", "5");

    // Vibenite290 --- Preheat (90mm Square)
    strategy = create_strategy("Vibenite290", "Preheat (90mm Square)", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "16.4");
    strategy->set_value("beam_speed", "5700");
    strategy->set_value("hatch_angle", "90");
    strategy->set_value("hatch_order", "1");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "100");
    strategy->set_value("num_counts", "20");

    // Ti6Al4V --- Preheat
    strategy = create_strategy("Ti6Al4V", "Preheat", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "30");
    strategy->set_value("beam_speed", "14600");
    strategy->set_value("hatch_angle", "90");
    strategy->set_value("hatch_order", "1");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "50");
    strategy->set_value("num_counts", "3");

    // TestMaterial --- Preheat
    strategy = create_strategy("TestMaterial", "Preheat", eb::pattern::object_type::hatch);
    strategy->set_value("beam_current", "30");
    strategy->set_value("beam_speed", "14600");
    strategy->set_value("hatch_angle", "90");
    strategy->set_value("hatch_order", "1");
    strategy->set_value("hatch_spacing", "1.2");
    strategy->set_value("line_order", "15");
    strategy->set_value("main_focus_offset", "50");
    strategy->set_value("num_counts", "3");


    return rc;
}


eb::rc generate_autoset(const std::string & material)
{
    eb::rc rc;

    eb::log::info("Generating autoset for material: {}", material);

    eb::pattern::material_autoset  & ma = autosets[material];
    ma.set_material(material);

    if (material == "TestMaterial") {
        
        ma.set_phases({ "PREHEAT", "MELT", "PREHEAT_2", "MELT_2" });

        ma.add_characteristic(eb::pattern::label_type::preheat,        eb::pattern::object_type::hatch,    "Preheat",        ma.phases()[0], eb::folder_type::system);
                                                                                                                             
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::tile,     "5mmTile",        ma.phases()[1], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "InnerContour",   ma.phases()[1], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "OuterContour",   ma.phases()[1], eb::folder_type::system);
                                                                                                                             
        ma.add_characteristic(eb::pattern::label_type::preheat,        eb::pattern::object_type::hatch,    "Preheat",        ma.phases()[2], eb::folder_type::system);
                                                                                                                             
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::tile,     "5mmTile",        ma.phases()[3], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "InnerContour",   ma.phases()[3], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "OuterContour",   ma.phases()[3], eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::closed_support, eb::pattern::object_type::hatch,    "ClosedSupports", ma.phases()[1], eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::open_support,   eb::pattern::object_type::contour,  "OpenSupports",   ma.phases()[1], eb::folder_type::system);
    }
    else if (material == "Ti6Al4V") {

        ma.set_phases({ "PREHEAT", "MELT" });

        ma.add_characteristic(eb::pattern::label_type::preheat,        eb::pattern::object_type::hatch,    "Preheat",        ma.phases()[0],     eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::tile,     "5mmTile",        ma.phases()[1],     eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "InnerContour",   ma.phases()[1],     eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,           eb::pattern::object_type::contour,  "OuterContour",   ma.phases()[1],     eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::closed_support, eb::pattern::object_type::hatch,    "ClosedSupports", ma.phases()[1],     eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::open_support,   eb::pattern::object_type::contour,  "OpenSupports",   ma.phases()[1],     eb::folder_type::system);


    }
    else if (material == "Vibenite290") {

        ma.set_phases({ "PREHEAT", "MELT" });

        ma.add_characteristic(eb::pattern::label_type::preheat, eb::pattern::object_type::hatch,   "Preheat (90mm Square)", ma.phases()[0], eb::folder_type::system);

        ma.add_characteristic(eb::pattern::label_type::part,    eb::pattern::object_type::tile,    "2.5mmTile",             ma.phases()[1], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,    eb::pattern::object_type::contour, "InnerContour",          ma.phases()[1], eb::folder_type::system);
        ma.add_characteristic(eb::pattern::label_type::part,    eb::pattern::object_type::contour, "OuterContour",          ma.phases()[1], eb::folder_type::system);

    }
    else {

        eb::log::error("Unknown material: {}", material);
        return eb::pattern::rc::invalid_material;
    }

    return rc;
}

eb::rc validate()
{
    for (auto & ma : autosets) {

        const std::string material = ma.first;
        
        // Check this material exists
        auto p = strategies.find(material);
        if (p == strategies.end()) {
            eb::log::error("No strategies defined for material: {}", material);
            return eb::pattern::rc::invalid_material;
        }

        for (auto & ct : ma.second.characteristics()) {

            for (auto & tl : ct.second) {

                std::string strategy_name = tl.strategy_set();

                auto q = p->second.find(strategy_name);
                if (q == p->second.end()) {
                    eb::log::error("No strategy named: {} defined for material: {}", strategy_name, material);
                    return eb::pattern::rc::invalid_strategy;
                }

                // Check same object type
                if (tl.geometry() != q->second->object_type()) {
                    eb::log::error("Strategy {}:{} has the wrong object type. Expected: {}, received: {}", material, strategy_name, eb::to_string(tl.geometry()), eb::to_string(q->second->object_type()));
                    return eb::pattern::rc::invalid_geometry;
                }
            }

        }

    }

    eb::log::info("Autosets passed strategy validation.");

    return eb::rc::success;
}


int main(int argc, const char *argv[])
{
    eb::rc rc;

    const std::vector<std::string> materials = {

        "Ti6Al4V",
        "Vibenite290",
        "TestMaterial"
    };

    // Start logging. Important to set the directory before
    // logging any messages, or we will be to late.
    std::string data_dir = eb::os::data_dir();
    std::string logdir = data_dir + "/logs/";

    // Start the log
    eb::log::instance()->init(logdir, "create_strategy");
    eb::log::instance()->enable_console();


    for (auto & material : materials) {


        rc = generate_autoset(material);
        if (rc.failed())
            return rc.code();


        rc = generate_strategy();
        if (rc.failed())
            return rc.code();

    }

    // Check it all adds up
    rc = validate();
    if (rc.failed())
        return rc;


    const std::string output_path = eb::os::data_dir() + "/data/system/strategy/";
    const std::string autoset_ext = ".autoset";
    const std::string strategy_ext = ".strategy";
    const std::string json_ext = ".json";

    // Now save all
    for (auto & ma : autosets) {

        rc = ma.second.save(output_path + ma.second.material() + json_ext);
        if (rc.failed())
            return rc;

        rc = ma.second.save(output_path + ma.second.material() + autoset_ext);
        if (rc.failed())
            return rc;

        eb::log::info("Saved autoset for material: {}", ma.first);
    }

    for (auto & material : strategies) {

        for (auto & st : material.second) {

            // Reset the modified flag 
            st.second->reset_modified();
        
            rc = st.second->save(output_path + st.second->name() + "_" + st.second->material() + json_ext);
            if (rc.failed())
                return rc;

            rc = st.second->save(output_path + st.second->name() + "_" + st.second->material() + strategy_ext);
            if (rc.failed())
                return rc;

            eb::log::info("Saved strategy: {} for material: {}", st.second->name(), st.second->material());

        }

    }


    return rc.code();
}
