'use server'

import { projectService } from "@/app/services";

export async function getProjects() {
    return projectService.getAll();
}

export async function getMenu() {
    return [
        {
            name: 'Dashboard',
            url: '/home'
        },
        {
            name: 'Proyectos',
            url: '/home/projects'
        },
        {
            name: 'Finanzas',
            url: '/home'
        }
    ]
}